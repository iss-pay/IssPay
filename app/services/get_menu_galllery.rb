module IssPay

  class GetMenuGallery

    def self.call(category, message_id)
      items = Item.where(category: category){quantity > 0}.all
      MenuGallery.new(items, message_id).to_json
    end
  end
end