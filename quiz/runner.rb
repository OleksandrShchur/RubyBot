module QuizName
  class Runner
    def initialize
      @quiz = Quiz.instance
      @input_reader = InputReader.new
      @file_writer = FileWriter.new
      @statistics = Statistics.new
    end

    def run
      @quiz.configure

      username = @input_reader.get_username
      start_time = Time.now

      engine = Engine.new
      engine.start

      result = engine.result
      end_time = Time.now
      @statistics.add_result(username, start_time, end_time, result)

      @file_writer.write_result(username, result)

      @file_writer.display_result(username, result)
    end
  end
end
  