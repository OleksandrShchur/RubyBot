module QuizBot
    class EngineBot
        attr_reader :config, :token, :logger, :quiz_engine, :question_correct_answer

        def initialize
            @config = AppConfigurator.new
            @config.configure
            #@token = @config.get_token
            #@logger = @config.get_logger
            #@quiz_engine = Quiz::Engine.new
            puts "Initializing the bot..."
        end

        def load_question
            db = SQLite3::Database.new("db/questions.sqlite")
            query = "SELECT * FROM quiz_questions ORDER BY RANDOM() LIMIT 1;"
            result = db.execute(query)
            row = result.first
            db.close
            @question_correct_answer = row[5]
            return row
        end

        def r
            puts "Running the bot..."
            token = '5965160742:AAHx79gJ06mJX41XL8akwhgIS3wHamLBSBE'

            Telegram::Bot::Client.run(token) do |bot|
                bot.listen do |message|
                    case message
                    when Telegram::Bot::Types::CallbackQuery
                        # Here you can handle your callbacks from inline buttons
                        if message.data.to_i == @question_correct_answer
                            bot.api.send_message(chat_id: message.from.id, text: "Правильно")
                        else
                            bot.api.send_message(chat_id: message.from.id, text: "Неправильно")
                        end
                    when Telegram::Bot::Types::Message
                        case message.text
                        when '/start'
                            bot.api.send_message(chat_id: message.chat.id, text: I18n.t(:greeting_message))
                        when '/stop'
                            bot.api.send_message(chat_id: message.chat.id, text: I18n.t(:farewell_message))
                        when '/c'
                            question = load_question()
                            #button1 = Telegram::Bot::Types::InlineKeyboardButton.new(text: question[2], callback_data: 'button_pressed')
                            #markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [[button1]])

                            #answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
                            #    keyboard: [
                            #        [{ text: 'A' }, { text: 'B' }],
                            #        [{ text: 'C' }, { text: 'D' }]
                            #    ],
                            #    one_time_keyboard: true
                            #)
                            kb = [[
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: question[2], callback_data: '1'),
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: question[3], callback_data: '2'),
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: question[4], callback_data: '3')
                            ]]
                            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
                            bot.api.send_message(chat_id: message.chat.id, text: question[1], reply_markup: markup)
                        end
                    end
                end
            end
        end
    end
end
