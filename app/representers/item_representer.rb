module IssPay

  class ItemRepresenter < Roar::Decorator
    include Roar::JSON

    property :name
    property :category
    property :price
    property :quantity
  end
end