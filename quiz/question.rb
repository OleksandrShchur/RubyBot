module QuizOleksandrShchur
    class Question
      attr_reader :text, :options, :answer
  
      def initialize(text, options, answer)
        @text = text
        @options = options
        @answer = answer
      end
    end
  end
  