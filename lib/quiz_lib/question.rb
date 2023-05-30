require 'json'
require 'yaml'

module QuizDorosh
  class Question
    attr_accessor :question_body, :question_correct_answer, :question_answers
    
    def initialize(question, answers, correct_answer)
      @question_body = question.strip
      @question_correct_answer = correct_answer
      @question_answers = answers
    end
    
    def display_answers
      @question_answers.each_with_index.map { |answer, index| "#{(index + 65).chr}.#{answer}" }
    end
    
    def to_s
      @question_body
    end
    
    def to_h
      {
        question_body: @question_body,
        question_correct_answer: @question_correct_answer,
        question_answers: @question_answers
      }
    end
    
    def to_json
      to_h.to_json
    end
    
    def to_yaml
      to_h.to_yaml
    end
    
    def load_answers(raw_answers)
      shuffled_answers = raw_answers.shuffle
      answers_hash = {}
      
      ('A'..'Z').each_with_index do |char, index|
        answers_hash[char] = shuffled_answers[index].strip
      end
      
      answers_hash
    end
    
    def find_answer_by_char(char)
      @question_answers[char]
    end
  end
end
