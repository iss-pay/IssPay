module IssPay

  class App < Roda
    
    route('item', 'v1') do |routing|
    end

    route('items', 'v1') do |routing|
      routing.get do
        result = Service::ListItems.new.call(routing.params)
        result.success.to_json
      end
    end
  end
end