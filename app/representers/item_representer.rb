module IssPay

  class ItemRepresenter < Roar::Decorator
    include Roar::JSON

    property :name
  end
end