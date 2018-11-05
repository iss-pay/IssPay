module IssPay

  class AddTransaction

    def self.call(data)
      if data['type'] == 'purchase'
        item = Item.find(id: data['item_id'])
        user = User.find(message_id: data['message_id'])
        transaction = Transaction.create(user_id: user.id, item_id: item.id, type: 'purchase', amount: item.price)
        {
          transaction:{
            type: transaction.type,
            amount: transaction.amount,
            user:{
              name: user.last_name + user.first_name,
            },
            item:{
              name: item.name,
              price: item.price
            }
          },
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
  end
end