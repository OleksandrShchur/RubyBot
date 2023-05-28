module QuizBot
    class EngineBot
        attr_reader :token, :quiz_engine

        def initialize
            @config = AppConfigurator.new
            @config.configure
            @token = @config.get_token
            @logger = @config.get_logger
            @quiz_engine = Quiz::Engine.new
        end

        def QuizBot
            Telegram::Bot::Client.run(token) { |bot| return bot 
        end

        def bot_listen
            bot.listen do |message|
                Thread.start(message) do |message|
                    #usr = user(rqst)
                    #case_message(rqst, usr)
                    options = {bot: bot, message: message, quiz: quiz_engine}

                @logger.debug "@#{message.from.username}: #{message.text}"
                MessageResponder.new(options).respond 
                end #Thread
            end #bot
        end
        


