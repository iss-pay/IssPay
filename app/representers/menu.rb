module IssPay

  module Representer
  
    class Menu

      def initialize(items, message_id)
        @items = items
        @purchase_url = App.config.APP_URL + "webhook/add_transaction?type=purchase&message_id=#{message_id}"
      end
      
      def to_json
        @items.map {|item| item_element(item)}
      end

      private
      def item_element(item)
        {
          "title": item.name,
          "image_url": item.image_url,
          "subtitle": "NTD$ #{item.price}, Quantity: #{item.quantity}",
          "buttons":[
             {
                "type": "web_url",
                "url": @purchase_url+"&item_ids[]=#{item.id}",
                "title": "購買 #{item.price}元商品"
             }
          ]
        }
      end
    end
  end
end