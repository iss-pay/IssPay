module IssPay

  class GetMenuGallery

    def self.call(category)
      items = Item.where(category: category){quantity > 0}.all
      MenuGallery.new(items).to_json
    end
  end
end