module IssPay

  class ItemRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :name
    property :category
    property :cost
    property :price
    property :quantity
    property :image_url
  end
end