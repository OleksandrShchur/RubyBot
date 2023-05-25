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
          username = message.from.first_name + " " + message.from.last_name
          start_time = Time.now

          engine = Engine.new(@bot, message.chat.id, username)
          engine.start

        when '/stop'
          result = engine.result
          end_time = Time.now

          puts start_time
          puts end_time

          @bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        end
      end
    end
  end
end
  