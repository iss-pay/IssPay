module IssPay
  
  class MenuGallery
    def initialize(items, message_id)
      @items = items
      @purchase_url = App.config.API_URL + "add_transaction?type=purchase&message_id=#{message_id}"
    end

    def to_json
      items_elements = @items.map {|item| item_element(item)}
      {
        "messages":[
          {
            "attachment":{
              "type":"template",
              "payload":{
                "template_type":"generic",
                "image_aspect_ratio":"square",
                "elements": items_elements
              }
            }
          },
        ]
      }
    end

    private
    def item_element(item)
      {
        "title": item.name,
        "image_url": item.image_url,
        "subtitle": "NTD$ #{item.price}, Total: #{item.quantity}",
        "buttons":[
           {
              "type": "json_plugin_url",
              "url": @purchase_url+"&item_id=#{item.id}",
              "title": "購買 #{item.price}元商品"
           }
        ]
      }
    end
  end
end