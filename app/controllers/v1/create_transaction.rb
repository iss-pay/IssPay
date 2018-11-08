module IssPay

  class App < Roda
    
    route('create_transaction') do |routing|
      routing.get do
        result = Service::CreateTransaction.new.call(routing.params)
        Representer::ChatBotMsg.new(result.success).transaction_response
      end
    end
  end
end