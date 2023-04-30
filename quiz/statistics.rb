module QuizName
    class Statistics
      attr_reader :user_scores
  
      def initialize
        @user_scores = {}
      end
  
      def add_user_score(username, score)
        if @user_scores[username].nil?
          @user_scores[username] = [score]
        else
          @user_scores[username] << score
        end
      end
  
      def average_score(username)
        return nil if @user_scores[username].nil?
  
        sum = @user_scores[username].sum
        count = @user_scores[username].count
        sum.to_f / count
      end
    end
  end
  