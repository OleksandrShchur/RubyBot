module QuizName
    class QuestionData
      attr_reader :questions
  
      def initialize(file_path)
        @questions = []
        parse_file(file_path)
      end
  
      private
  
      def parse_file(file_path)
        questions_data = YAML.load_file(file_path)
        questions_data.each do |question_data|
          text = question_data['text']
          options = question_data['options']
          answer = question_data['answer']
          @questions << Question.new(text, options, answer)
        end
      end
    end
  end
  