module IssPay

  module Representer
    class Menu
      def initialize(items, total, page, message_id)
        @items = items
        @total = total
        @page = page.to_i + 1
        @message_id = message_id
        @purchase_url = App.config.API_URL + "create_transaction?response_type=chatbot_msg&type=purchase&message_id=#{message_id}"
      end

      def to_json
        elements = @items.map {|item| item_element(item)}
        elements.concat([next_page_element(@page, @items[0].category, @message_id)])
        {
          "messages":[
            {
              "attachment":{
                "type":"template",
                "payload":{
                  "template_type":"generic",
                  "image_aspect_ratio":"square",
                  "elements": elements
                }
              }
            },
          ]
        }
      end

      private
      def item_element(item)       
        {
          "title": item.name,
          "image_url": item.image_url,
          "subtitle": "NTD$ #{item.price}; Quantity: #{item.quantity}",
          "buttons":[
            {
                "type": "json_plugin_url",
                "url": @purchase_url+"&item_ids[]=#{item.id}",
                "title": "購買 #{item.price}元商品"
            }
          ]
        }
      end

      def next_page_element(page, category, message_id)
        {
          "title": "想看更多嗎",
          "image_url": "https://cdn1.iconfinder.com/data/icons/general-9/500/more-512.png",
          "subitle": "Total Items: 10",
          "buttons":[
            {
              "type": "json_plugin_url",
              "url": "#{App.config.API_URL}items?category=#{category}&page=#{page}&message_id=#{message_id}&response_type=chatbot_msg",
              "title": "來更多"
            }
          ]
        }
      end
    end
  end
end