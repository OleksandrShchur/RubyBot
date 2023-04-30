module QuizName
    class Statistics
        attr_reader :correct_answers, :incorrect_answers
      
        def initialize(writer)
          @correct_answers = 0
          @incorrect_answers = 0
          @writer = writer
        end
      
        def correct_answer
          @correct_answers += 1
        end
      
        def incorrect_answer
          @incorrect_answers += 1
        end
      
        def print_report
          total_answers = @correct_answers + @incorrect_answers
          if total_answers == 0
            percent_correct = 0
          else
            percent_correct = (@correct_answers.to_f / total_answers.to_f) * 100
          end
      
          report = "Total questions: #{total_answers}\n"
          report += "Correct answers: #{@correct_answers}\n"
          report += "Incorrect answers: #{@incorrect_answers}\n"
          report += "Percentage correct: #{'%.2f' % percent_correct}%\n"
      
          @writer.write(report)
        end
      end
      
  