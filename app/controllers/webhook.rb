module IssPay
  
  class App < Roda
    route('webhook') do |routing|
      
      routing.on 'menu' do
        routing.post do
          Service::GetMenu.call(routing.params['category'], routing.params['message_id'])
        end
      end 
      
      routing.on 'add_transaction' do
        routing.get do
          result = AddTransaction.call(routing.params)
          result
        end
      end
    end
  end
end