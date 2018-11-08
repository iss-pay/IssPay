module IssPay

  module Representer
    
    class ChatBotMsg

      def initialize(obj)
        @obj = obj
      end

      def type
        @type
      end

      def http_code
      end

      def transaction_response
        items_name = @obj.map {|t| t.item.name}.reduce(:+)
        amount = @obj.map(&:amount).reduce(:+)
        {
          "messages":[
            {"text": "成功購買 #{items_name}, 總額 #{amount}"}
          ]
        }
      end

      def general_response
        {
          "messages": [
            {"text": @obj}
          ]
         }
      end
    end
  end
end