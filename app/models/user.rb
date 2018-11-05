module IssPay
  
  class User < Sequel::Model(:users)
    many_to_many :purchases, class: 'IssPay::Item',
                  join_table: :transactions,
                  left_key: :user_id, right_key: :item_id
    many_to_many :givers, class: 'IssPay::User',
                  join_table: :transactions,
                  left_key: :user_id, right_key: :receiver
    many_to_many :receivers, class: 'IssPay::User',
                  join_table: :transactions,
                  left_key: :receiver, right_key: :user_id

    
  end
end