require_relative 'user_representer'
require_relative 'item_representer'

module IssPay

  class TransactionRepresenter < Roar::Decorator
    include Roar::JSON

    property :owner, exntend: UserRepresenter do
      property :full_name
    end
    property :item, extned: ItemRepresenter do
      property :name
    end
    property :receiver, extend: UserRepresenter do
      property :full_name
    end
    property :type
    property :status
    property :amount
    property :created_at
  end
end