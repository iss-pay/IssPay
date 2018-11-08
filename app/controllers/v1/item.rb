module IssPay

  class App < Roda
    
    route('item') do |routing|
    end

    route('items') do |routing|
      routing.get do
        result = Service::ListItems.new.call(routing.params)
        result.success.to_json
      end
    end
  end
end