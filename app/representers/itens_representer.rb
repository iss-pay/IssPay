require_relative 'item_representer'

module IssPay

  class ItemsRepresenter < Roar::Decorator
    include Roar::JSON

    collection :items, extend: ItemRepresenter
  end
end