module IssPay

  module Representer
    
    class ChatBotMsg

      def initialize(obj)
        @obj = obj
        @app = IssPay::App
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
            {"text": "成功購買 #{items_name}, 總額 #{amount}"},
            {
              "attachment": {
                "type": "template",
                "payload": {
                  "template_type": "button",
                  "text": "按錯了嗎？這裡可以取消購買!!",
                  "buttons": @obj.map do |transaction|
                    {
                      "type": "json_plugin_url",
                      "title": "取消購買#{transaction.item.name}",
                      "url": "#{@app.config.API_URL}delete_transaction/#{transaction.id}"
                    }
                  end
                }
              }
            }
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

      def send_balance
        text = @obj.balance < 0 ?  "餘額#{@obj.balance},還不來還錢!" : "餘額#{@obj.balance},還不來消費!"
        [
          "messages":[
            {"text": text}
          ]
        ]
      end
    end
  end
end