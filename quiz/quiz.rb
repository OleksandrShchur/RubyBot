require 'singleton'

module QuizName
  class Quiz
    include Singleton

    attr_accessor :username

    def initialize
      @username = ''
    end

    def configure
      yield self
    end
  end
end