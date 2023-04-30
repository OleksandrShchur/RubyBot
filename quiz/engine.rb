require_relative 'question'
require_relative 'question_data'
require_relative 'file_writer'
require_relative 'input_reader'
require_relative 'statistics'
require_relative 'quiz'
require 'yaml'
require 'json'
require 'pathname'

module QuizName
  class Engine
    def initialize
      @question_collection = []
      yaml_path = Pathname.new(QuizName::Quiz.instance.yaml_dir)
      Dir[yaml_path.join("*." + QuizName::Quiz.instance.in_ext)].each do |file|
        data = QuizName::QuestionData.from_file(file)
        data.questions.each { |q| @question_collection << QuizName::Question.new(q) }
      end
      @input_reader = QuizName::InputReader.new
      @user_name = @input_reader.read('Enter your name: ')
      @current_time = Time.now.strftime("%d-%m-%Y %H:%M:%S")
      @writer = QuizName::FileWriter.new('a', QuizName::Quiz.instance.answers_dir, "#{@user_name}_#{@current_time}.txt")
      @statistics = QuizName::Statistics.new(@writer)
    end

    def run
      puts "Welcome, #{@user_name}!"
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
      @statistics.print_report
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
  end
end
