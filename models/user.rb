class User < ActiveRecord::Base
    has_many :quiz_tests
end
      
