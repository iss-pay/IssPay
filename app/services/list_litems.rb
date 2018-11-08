require 'dry-monads'
require 'dry/transaction'
module IssPay

  module Service
    
    class ListItems
      include Dry::Transaction

      step :list_items
      step :pagination
      step :response_with_type

      def list_items(input)
        input['items'] = Item.where(category: input['category']).all 
        if input['items'] .empty?
          Failure(Representer::ChatBotMsg.new("沒有任何商品了!~", 'notice'))
        else
          Success(input)
        end
      end

      def pagination(input)
        current_page = input['page']
        Right(input) if input['page'].nil?
        input['paginated_items'] = input['items'].drop((current_page.to_i - 1) * 8).shift(8)
        
        if input['paginated_items'].empty?
          Failure(Representer::ChatBotMsg.new("沒有任何商品了!~", 'notice'))
        else
          Success(input)
        end
      end

      def response_with_type(input)
        if input['response_type'] == 'chatbot_msg'
          Success(Representer::Menu.new(input['paginated_items'], input['items'].count, input['page'], input['message_id']))
        end
      end
    end
  end
end