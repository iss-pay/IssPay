module IssPay

  module Service
    class GetMenu

        def self.call(category, message_id)
          items = Item.where(category: category){quantity > 0}.all
          menu = Representer::Menu.new(items, message_id).to_json
          # send_menu(menu, message_id)
          {
            status: 'ok',
            message: 'successful'
          }
        end

        private
        # def self.send_menu(menu,message_id)
        #   bot = FbMessenger::Bot::Sender.new(message_id)
        #   bot.elements = menu
        #   bot.send_generic 
        # end
    end
  end
end