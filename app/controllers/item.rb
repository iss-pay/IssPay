module IssPay
  
  class App < Roda
    route('item') do |routing|
      routing.on 'list' do
        routing.get do
          view 'item/list'
        end
      end

      routing.post do
        
      end
    end
  end
end