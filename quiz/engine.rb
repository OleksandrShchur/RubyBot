module QuizName
    class Engine
      def initialize(question_data, input_reader, file_writer, statistics)
        @question_data = question_data
        @input_reader = input_reader
        @file_writer = file_writer
        @statistics = statistics
      end
  
      def run_quiz
        @score = 0
        @question_data.questions.each do |question|
          puts question.text
          question.options.each_with_index do |option, index|
            puts "#{index + 1}. #{option}"
          end
  
          user_answer = @input_reader.get_input.to_i - 1
          correct_answer = question.answer
  
          if user_answer == correct_answer
            puts 'Correct!'
            @score += 1
          else
            puts 'Incorrect!'
          end
        end
  
        puts "You scored #{@score} out of #{@question_data.questions.count}"
        @file_writer.write("#{Quiz.instance.username} #{@score}")
        @statistics.add_user_score(Quiz.instance.username, @score)
      end
    end
  end
  