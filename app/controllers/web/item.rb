module IssPay
  
  class App < Roda
    route('item') do |routing|
      routing.post do
        item = Item.create(routing.params)
        { 
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image_url: item.image_url,
          category: item.category
        }
      end
      routing.on String do |item_id|
        routing.put do
          item = Item.find(id: item_id)
          item.update(routing.params)
          item.save 
          ItemRepresenter.new(item).to_json
        end
      end
    end

    route('items') do |routing|
      routing.get do
        @item = Item
        view 'item/items', locals: {item: @item}
      end
    end
  end
end