module IssPay

  class App < Roda
    
    route('add_transaction') do |routing|
      
        routing.get do
          puts routing.params
          result = AddTransaction.call(routing.params)
          {
            "messages": [
              {"text": "Purchase successful."}
            ]
          }
        end
    end
  end
end