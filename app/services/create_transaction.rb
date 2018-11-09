
module IssPay

  module Service
    
    class CreateTransaction
      include Dry::Transaction

      step :check_transaction_info
      step :create_transaction

      def check_transaction_info(input)
        input['items'] = input['item_ids'].map{|item_id| Item.find(id: item_id)} unless input['item_ids'].nil?
        input['recevier'] = User.find(message_id: input['receiver_id']) unless input['receiver_id'].nil?
        input['user'] = User.find(message_id: input['message_id']) unless input['message_id'].nil?

        if ( ( present?(input['items']) || present?(input['recevier']) ) && present?(input['user']) )
          Success(input)
        else
          Failure()
        end
      end

      def create_transaction(input)
        if(input['type'] == 'purchase')
          transactions = input['items'].map do |item|
            Transaction.create(user_id: input['user'].id, item_id: item.id, type: 'purchase', amount: item.price)
          end
          Success(transactions)
        elsif (input['type' == 'transfer'])
        end
      end

      private

      def present?(obj)
        !obj.nil?
      end
    
    end
  end
end