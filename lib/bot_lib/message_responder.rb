module QuizBot
   class MessageResponder
    attr_reader :message
    attr_reader :bot
    attr_reader :quiz_engine
    attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @quiz_engine = options[:quiz]
    @user = User.find_or_create_by(uid: message.from.id, username:message.from.first_name)
    p @user
  end

  def respond
    on /^\/start\W+(\w+)/ do |param|
      answer_with_greeting_message(param: param)
    end

    on /^\/stop(\w+)/ do |param|
      answer_with_farewell_message (param: param)
    end
  end

  private

  def on (regex, &block)
    regex =~ @message.text

    puts "block.arity = #{block.arity}"

    if $~
      case block.arity
      when 0
        yield
      when 1
        puts "$1 -> #{$1}"
        yield $1
      when 2
        yield $1, $2
      end
    end
  end

  on on /^([ABC])/ do |param|
    question = quiz_engine.question_collection.collection[@current_question]
    user_answer = question.find_answer_by_char(arg)
    p user_answer
    quiz_engine.writer.write "User_answer is #{user_answer}\n"
    if check (user_answer, question.question_correct_answer)
      text = "Вірно"
    else 
      text = "Не вірно"
    end
    answer_with_message(text)

    @current_question +=1
    if display_question_i(@current_question)
      @user_quiz_test.current_question = @current_question
      @user_quiz_test.save
    else
      finish_quiz
    end
  end

  def answer_with_greeting_message (param: nil)
    puts param unless param 
    I18n.locate = :ua
    answer_with_message I18n.t(:greeting_message)
  end

  def answer_with_farewell_message (param: nil)
    puts param unless param 
    I18n.locate = :ua
    answer_with_message I18n.t(:farewell_message)
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
end