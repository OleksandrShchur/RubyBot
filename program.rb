require 'telegram/bot'

require './quiz/runner'

token = '6296620491:AAF23t__Ic5pDAvGjSFJu5RfiYDHG2BQL6k'

Telegram::Bot::Client.run(token) do |bot|
  runner_quiz = QuizName::Runner.new(bot)
  runner_quiz.run
end
