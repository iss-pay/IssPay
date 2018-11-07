module IssPay

  class AddTransaction

    def self.call(data)
      if data['type'] == 'purchase'
        items = data['item_ids'].map{|item_id| Item.find(id: item_id)}
        user = User.find(message_id: data['message_id'])
        transactions = items.map do |item|
          Transaction.create(user_id: user.id, item_id: item.id, type: 'purchase', amount: item.price)
        end
        send_notification(data['message_id'], items)
        {
          transactions: transactions.map {|t| transaction_json(t, user)}
        }
      elsif data['type'] == 'transfer'
        receiver = User.find(message_id: data['receiver_id'])
        user = User.find(message_id: data['message_id'])
        transaction = Transaction.create(user_id: user.id, receiver: receiver.id, type: 'tansfer', amount: data['amount'])
        {
          transaction:{
            type: transaction.type,
            amount: transaction.amount,
            user:{
              name: user.last_name + user.first_name
            },
            receiver:{
              name: receiver.last_name + receiver.first_name
            }
          }
        }
      end
    end

    private

    def self.send_notification(message_id, items)
      bot = FbMessenger::Bot::Sender.new(message_id)
      items = items.map(&:name).reduce{ |result, name| result + "; #{name}"  }
      bot.send_text("成功購買#{items}")
    end

    def self.transaction_json(transaction, user)
      {
        type: transaction.type,
            amount: transaction.amount,
            user:{
              name: user.last_name + user.first_name,
            },
            item:{
              name: transaction.item.name,
              price: transaction.item.price
            }
      }
    end
  end
end