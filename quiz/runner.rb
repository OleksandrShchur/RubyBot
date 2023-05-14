require_relative 'quiz'
require_relative 'input_reader'
require_relative 'file_writer'
require_relative 'statistics'
require_relative 'engine'

module QuizName
  class Runner
    def initialize(bot)
      @quiz = Quiz.instance
      @input_reader = InputReader.new
      @bot = bot
    end

    def run
      @bot.listen do |message|
        case message.text
        when '/start'
          @bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        when '/stop'
          @bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        end
      end

      username = @input_reader.get_username
      start_time = Time.now

      engine = Engine.new(@bot)
      engine.start

      result = engine.result
      end_time = Time.now
    end
  end
end
  