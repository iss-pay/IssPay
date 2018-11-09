module IssPay

  class App < Roda
    
    route('create_transaction', 'v1') do |routing|
      routing.get do
        result = Service::CreateTransaction.new.call(routing.params)
        Representer::ChatBotMsg.new(result.success).transaction_response
      end
    end

    route('delete_transaction', 'v1') do |routing|
      routing.on String do |transaction_id|
        transaction = Transaction.find(id: transaction_id)
        if transaction.destroy 
          Representer::ChatBotMsg.new("成功取消購買").general_response
        end
      end 
    end
  end
end