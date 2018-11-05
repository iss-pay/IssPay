module IssPay
  
  class MenuGallery
    def initialize(items)
      @items = items
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
        "title": item.item_name,
        "image_url": item.image_url,
        "subtitle": "NTD$ #{item.price}",
        "buttons":[
           {
              "type": "json_plugin_url",
              "url": "purchase_url",
              "title": "購買 #{item.price}元商品"
           }
        ]
      }
    end
  end
end