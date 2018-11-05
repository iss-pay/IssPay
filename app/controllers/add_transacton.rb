module IssPay

  class App < Roda
    
    route('add_transaction') do |routing|
      
        routing.get do
          result = AddTransaction.call(routing.params)
          result
        end
    end
  end
end