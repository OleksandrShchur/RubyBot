module QuizName
    class FileWriter
      def initialize(file_path)
        @file_path = file_path
      end
  
      def write(data)
        File.open(@file_path, 'a') do |f|
          f.puts(data)
        end
      end
    end
  end
  