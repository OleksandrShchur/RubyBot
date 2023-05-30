require 'singleton'

module QuizDorosh
  class Quiz
    include Singleton

    attr_accessor :yaml_dir, :in_ext, :answers_dir, :log_dir

    def initialize
      @yaml_dir = "./yml"
      @in_ext = "*.yml"
      @answers_dir = ""
      @log_dir = ""
    end

    def self.config(&block)
      instance.config(&block)
    end

    def config(&block)
      yield self
    end
  end
end
