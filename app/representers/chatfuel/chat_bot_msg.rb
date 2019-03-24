require_relative 'message'
require_relative 'text'

module IssPay

  module Representer

    class ChatBotMsg

      CONFIG = IssPay::App.config

      def self.transaction_response(transactions)
        items_name = transactions.map{|t| t.item.name }.reduce(:+)
        amount = transactions.map(&:amount).reduce(:+)
        texts = texts = ChatFuel::Text.new(*"成功購買 #{items_name}, 總額 #{amount}")
        buttons = transactions.map do |t|
          {
            "title" => "取消購買 #{t.item.name}",
            "url" => "#{CONFIG.API_URL}delete_transaction/#{t.id}"
          }
        end
        attachments = ChatFuel::Attachment.new(type: 'template', payload: button_payload("案錯了嗎，這裡可以取消購買！", buttons))
        ChatFuel::Message.new(texts: texts, attachments: attachments).to_json
      end

      def self.send_menu_gallery(items, page, user)
        purchase_url = CONFIG.API_URL + "create_transaction?response_type=chatbot_msg&type=purchase&message_id=#{user.message_id}"
        elements = items_elements(items, purchase_url)
        elements.push(next_page_element(page, items[0].category, user.message_id))
        attachments = ChatFuel::Attachment.new(type: 'template', payload: gallery_payload(elements))
        ChatFuel::Message.new(attachments: attachments).to_json
      end

      def self.send_text(*text)
        texts = ChatFuel::Text.new(*text)
        ChatFuel::Message.new(texts: texts).to_json
      end

      def self.send_balance(user)
        texts = nil
        attachments = nil
        if user.balance < 0
          texts = ChatFuel::Text.new("餘額#{user.balance},還不來還錢!")
          buttons = [{'title' => "還$#{user.balance}元", "url" => "#{CONFIG.API_URL}pay_all_transactions/#{user.message_id}"}]
          attachments = ChatFuel::Attachment.new(type: 'template', payload: button_payload("要還款了嗎???快按這裡還錢~~", buttons))
        else
          texts = ChatFuel::Text.new("餘額#{user.balance},還不來消費!")
          buttons = [{'title' => "來點飲料", "url" => "#{CONFIG.API_URL}items?category=Drink&page=1&message_id=#{user.message_id}&response_type=chatbot_msg"},
                      {'title' => "來點零食", "url" => "#{CONFIG.API_URL}items?category=Snack&page=1&message_id=#{user.message_id}&response_type=chatbot_msg"}]
          attachments = ChatFuel::Attachment.new(type: 'template', payload: button_payload("快來買點什麼吧~~", buttons))
        end
        ChatFuel::Message.new(texts: texts, attachments: attachments).to_json
      end

      private

      def self.gallery_payload(elements)
        {
          "template_type": "generic",
          "image_aspect": "square",
          "elements": elements
        }
      end

      def self.items_elements(items, purchase_url)
        items.map do |item|
          {
            "title": item.name,
            "image_url": item.image_url,
            "subtitle": "NTD$ #{item.price}; Quantity: #{item.quantity}",
            "buttons": buttons_element([{"title" => "購買 #{item.price}元商品" ,"url" => purchase_url+"&item_ids[]=#{item.id}"}])
          }
        end
      end

      def self.next_page_element(page, category, message_id)
        {
          "title": "想看更多嗎",
          "image_url": "https://cdn1.iconfinder.com/data/icons/general-9/500/more-512.png",
          "subitle": "Total Items: 10",
          "buttons": buttons_element([{"title" => "看更多", "url" => "#{CONFIG.API_URL}items?category=#{category}&page=#{page}&message_id=#{message_id}&response_type=chatbot_msg"}])
        }
      end


      def self.button_payload(text,buttons)
        {
          "template_type": "button",
          "text": text,
          "buttons": buttons_element(buttons)
        }
      end

      def self.buttons_element(buttons)
        buttons.map do |button|
          {
            "type": "json_plugin_url",
            "title": button['title'],
            "url": button['url']
          }
        end
      end

    end
  end
end