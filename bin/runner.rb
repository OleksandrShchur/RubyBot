require_relative "../lib/load_libraries"

Root_Path = File.join(File.dirname(__FILE__), "../")

QuizDorosh::Quiz.config do |quiz|
 quiz.yaml_dir = File.join(Root_Path, "config", "quiz_yml")
 quiz.answers_dir = File.join(Root_Path, "quiz_answers")
 quiz.log_dir = File.join(Root_Path, "log")
end

#QuizBot.config do |quiz_bot|
   #quiz_bot.yaml_dir = File.join(Root_Path, "config")
   #quiz_bot.log_dir = File.join(Root_Path, "log")
 #end

engine = QuizBot::EngineBot.new
engine.r


