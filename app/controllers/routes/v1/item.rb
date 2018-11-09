module IssPay

  class App < Roda
    
    route('item', 'v1') do |routing|
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