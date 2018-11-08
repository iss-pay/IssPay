module IssPay

  module Representer
    
    class ChatBotMsg

      def initialize(msg, type)
        @msg = msg
        @tpye =type
      end

      def type
        @type
      end

      def http_code
      end

      def to_json
        {
          "messages": [
            {"text": @msg}
          ]
         }
      end
    end
  end
end