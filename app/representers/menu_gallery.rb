module IssPay
  
  class MenuGallery
    def initialize(items, message_id)
      @items = items
      @purchase_url = App.config.API_URL + "add_transaction?type=purchase&message_id=#{message_id}"
    end

    def to_json
      items_elements = @items.map {|item| item_element(item)}
      {
        "messages": [
          {
            "text":  "Did you enjoy the last game of the CF Rockets?",
            "quick_replies": items_elements
          }
        ]
      }
    end

    private
    def item_element(item)
      {
        "title": "#{item.name}: $#{item.price}",
        "url": @purchase_url
        "type": "json_plugin_url"
      }
    end
  end
end