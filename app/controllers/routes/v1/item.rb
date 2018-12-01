module IssPay

  class App < Roda
    
    route('item', 'v1') do |routing|
      routing.post do
        routing.params
      end

      routing.is String do |item_id|
        routing.put do
          item = Item.find(id: item_id)
          item.update(routing.params)
          item.save 
          ItemRepresenter.new(item).to_json
        end

        routing.delete do 
          item = Item.find(id: item_id)
          if !item.nil? && item.destroy
            {"message" => "成功刪除#{item.name}"}
          end
        end
      end
    end

    route('items', 'v1') do |routing|
      routing.get do
        result = Service::ListItems.new.call(routing.params)
        if result.success?
          result.success.to_json
        else
          result.failure.general_response
        end
      end
    end
  end
end