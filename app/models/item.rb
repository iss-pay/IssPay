module IssPay

  class Item < Sequel::Model(:items)
    many_to_many :purchasers, class: 'IssPay::User',
                  join_table: :transactions,
                  left_key: :item_id, right_key: :user_id
  end
end