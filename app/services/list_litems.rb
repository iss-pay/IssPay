require 'dry-monads'
require 'dry/transaction'
module IssPay

  module Service

    class ListItems
      include Dry::Transaction

      step :overdraft?
      step :list_items
      step :pagination
      step :response_with_type

      def overdraft?(input)
        user = User.find(message_id: input['message_id'])
        last_unpay_transactions = Transaction.where(user_id: user.id, status: 0){created_at < Time.now.strftime("%Y-%m")}.all
        if input['response_type'] == 'chatbot_msg' && last_unpay_transactions.count > 0
          Failure(Representer::ChatBotMsg.send_text("你#{Time.now.strftime("%Y-%m")}之前的帳款沒還，請先還錢！"))
        else
          input['user'] = user
          Success(input)
        end
      end

      def list_items(input)
        input['items'] = input['response_type'].nil? ? Item.where(category: input['category']).all : Item.order(:id).where(category: input['category']){quantity > 0}.all
        if input['items'].empty?
          Failure(Representer::ChatBotMsg.send_text("沒有任何商品了"))
        else
          Success(input)
        end
      end

      def pagination(input)
        return Success(input) if input['page'].nil?
        current_page = input['page']
        input['paginated_items'] = input['items'].drop((current_page.to_i - 1) * 8).shift(8)

        if input['paginated_items'].empty?
          Failure(Representer::ChatBotMsg.send_text("沒有任何商品了"))
        else
          Success(input)
        end
      end

      def response_with_type(input)
        if input['response_type'] == 'chatbot_msg'
          Success(Representer::ChatBotMsg.send_menu_gallery(input['paginated_items'], input['page'].to_i + 1, input['user']))
        elsif input['response_type'].nil?
          Success(ItemsRepresenter.new(Items.new(input['items'] || input['paginated_items'])))
        end
      end
    end
  end
end