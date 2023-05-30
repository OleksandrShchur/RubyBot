require_relative 'question'
require_relative 'question_data'
require_relative 'file_writer'
require_relative 'input_reader'
require_relative 'statistics'
require_relative 'quiz_dorosh'
require 'yaml'
require 'json'
require 'pathname'

module QuizName
  class Engine
    def initialize(bot, chat_id, username)
      @bot = bot
      @chat_id = chat_id
      @username = username

      @question_collection = []

      @question_data = QuestionData.new
      @question_data.load_data
      
      @current_time = Time.now.strftime("%d-%m-%Y %H:%M:%S")
      @writer = QuizName::FileWriter.new('a', QuizName::Quiz.instance.answers_dir, "#{@user_name}_#{@current_time}.txt")
      @statistics = QuizName::Statistics.new(@writer)
    end

    def start
      @bot.api.send_message(text: "Welcome, #{@username}!", chat_id: @chat_id)

      puts @question_collection

      @question_collection.each_with_index do |question, index|
        puts "\nQuestion #{index + 1}: #{question.text}"
        question.options.each_with_index do |option, option_index|
          puts "#{('A'..'Z').to_a[option_index]}) #{option}"
        end
        user_answer = get_answer_by_char(question)
        check(user_answer, question.answer)
        puts "\nYour answer: #{user_answer}"
        puts "Correct answer: #{question.answer}"
      end
      puts "\nQuiz finished!"
      #@statistics.print_report
    end

    def check(user_answer, correct_answer)
      if user_answer == correct_answer
        @statistics.correct_answer
      else
        @statistics.incorrect_answer
      end
    end

    def get_answer_by_char(question)
      loop do
        user_answer = @input_reader.read('Enter your answer: ').upcase.strip
        return user_answer unless user_answer.empty?
      end
    end

    def start_bot()
      # відповіді на питання(чи правильні і на яке)
      answers_to_questions = {}
      @question_data.collection.each_with_index do |question, index|
        answers_to_questions[:index] = nil
      end
      # генератор запитань
      question_collection_enumerator = @question_data.collection.each
      # останнє запитання яке було відправлене та його індекс 
      index_question_collection = -1
      last_question = nil
      # останнє запитання через /c та його індекс
      last_c_question = nil
      last_c_question_index = nil

      @bot.listen do |message|
        case message.text
        # /stop
        when '/stop'
          return stop(message)
        # питання на вибір через /c
        when /^\/c \d+$/
          index = message.text.match("\\d+").to_s.to_i
          # якщо номер запитання більший за кількість запитань
          if index > @question_data.collection.length - 1
            @bot.api.send_message(chat_id: message.chat.id, text: "нема такого питання")
          else
            question = @question_data.collection[index]
            send_question(question, message, index)
            last_c_question = question
            last_c_question_index = index
          end
        # інакше перевіряємо відповіді на запитання
        else
          # чи це відповідь на /c 
          it_is_c_question = false
          if last_c_question != nil
            it_is_c_question = true
          end
          # перевіряємо відповідь 
          if it_is_c_question
            parse_respond_c_question(message, last_c_question, answers_to_questions, last_c_question_index)          
            last_c_question = nil
            last_c_question_index = nil
          elsif last_question != nil
            parse_respond_question(message, last_question, answers_to_questions, index_question_collection) 
          end
          # якщо /c то відповідаємо знову простим питанням
          if (it_is_c_question && last_question != nil)
            question = last_question
          else
            begin
              question = question_collection_enumerator.next
              index_question_collection += 1
            # Якщо це останнє повідомлення то зупиняємось
            rescue StopIteration => ex
              stop(message)
              return
            end
          end
          send_question(question, message, index_question_collection)
          last_question = question
        end
      end
    end

    def stop(message)
      # якщо стоп, то виводимо результати та виходимо
      kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      report = @statistics.get_report()
      percent = @statistics.get_percent()
      if percent == 0
        @bot.api.send_message(chat_id: message.chat.id, text: "😕", reply_markup: kb)
      elsif percent == 100
        @bot.api.send_message(chat_id: message.chat.id, text: "🥳", reply_markup: kb)
      end
      @bot.api.send_message(chat_id: message.chat.id, text: report, reply_markup: kb)
    end

    def send_question(question, message, index_question_collection)
      # функція для відправки запитанняз кнопками
      question_text = index_question_collection.to_s + "."  + question.question_body
      question_correct_answer = question.question_correct_answer
      question_answers = question.question_answers
      text_answers = []
      question_answers.each do |answer|
        text_answers << [{text: answer}]
      end
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
            keyboard: text_answers,
            one_time_keyboard: true
          )
      @bot.api.send_message(chat_id: message.chat.id, text: question_text, reply_markup: answers)
    end

    def parse_respond_c_question(message, last_c_question, answers_to_questions, last_c_question_index)
      # якщо відповідь на питання з /c правильна
      if message.text == last_c_question.question_correct_answer
        # якщо ще не було відповідей на таке питання
        if answers_to_questions[last_c_question_index] == nil
          @statistics.correct_answer()
        # якщо була відповідь, помилковa
        elsif answers_to_questions[last_c_question_index] == false
          @statistics.correct_answer()
          @statistics.delete_incorrect_answer()
        end
        answers_to_questions[last_c_question_index] = true
        @bot.api.send_message(chat_id: message.chat.id, text: "👍", reply_to_message_id: message.message_id)
      # не правильна
      else
        # якщо ще не було відповідей на таке питання
        if answers_to_questions[last_c_question_index] == nil
          @statistics.incorrect_answers()
        # якщо відповідь була правильною
        elsif answers_to_questions[last_c_question_index] == true
          @statistics.incorrect_answer()
          @statistics.delete_correct_answer()
        end
        answers_to_questions[last_c_question_index] = false
        @bot.api.send_message(chat_id: message.chat.id, text: "👎", reply_to_message_id: message.message_id)
      end
    end

    def parse_respond_question(message, last_question, answers_to_questions, index_question_collection)      
      # якщо відповідь на питання була правильна
      if message.text == last_question.question_correct_answer
        @statistics.correct_answer()
        answers_to_questions[index_question_collection] = true
        @bot.api.send_message(chat_id: message.chat.id, text: "👍", reply_to_message_id: message.message_id)
      # якщо не правильна
      else
        answers_to_questions[index_question_collection] = false
        @bot.api.send_message(chat_id: message.chat.id, text: "👎", reply_to_message_id: message.message_id)
        @statistics.incorrect_answer()
      end
    end
  end
end
