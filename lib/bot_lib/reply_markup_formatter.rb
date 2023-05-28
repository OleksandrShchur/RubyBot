class ReplyMarkupFormatter
    attr_reader :array
  
    def initialize(array)
      @array = array
    end
  
    def get_markup(options: options)
      options ||- {}
      options[:one_time_keyboard] = true unless options.has_key?(:one_time_keyboard)
      options[:resize_keyboard] = true unless options.has_key?(:resize_keyboard)

      Telegram::Bot::Types::ReplyKeyboardMarkup
        .new(keyboard: array.each_slice(1).to_a, 
            one_time_keyboard: options[:one_time_keyboard],
            resize_keyboard: options[:resize_keyboard])
      
    end
  end
end