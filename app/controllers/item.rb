module IssPay
  
  class App < Roda
    route('item') do |routing|

      routing.on 'list' do
        routing.get do

        end
      end

      routing.post do
        item = Item.create(routing.params)
        item_amount = Item.where(category: routing.params['category']).all.count
        {
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image_url: item.image_url,
          category: item.category,
          amount: item_amount
        }
      end
    end
  end
end