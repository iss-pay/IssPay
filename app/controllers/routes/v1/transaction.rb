module IssPay

  class App < Roda
    route('transaction', 'v1') do |routing|
      routing.get do
        {"test" => "test transaction."}
      end

      routing.post do
        result = Service::CreateTransaction.new.call(routing.params)
        if result.success?
          TransactionsRepresenter.new(Transactions.new(result.success)).to_json
        end
      end
    end

    route('transactions', 'v1') do |routing|
      routing.on String do |message_id|
        routing.get do
          user = User.find(message_id: message_id)
          transactions = Transaction.where(user_id: user.id).all
          TransactionsRepresenter.new(Transactions.new(transactions)).to_json
        end
      end
    end
  end
end