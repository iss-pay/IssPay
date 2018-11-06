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

    def full_name
      last_name + first_name
    end
    
    def admin?
      member_type == 'Admin'
    end

    def purchase_debits
      Transaction.where(user_id: id, type:'purchase').all
    end

    def transfer_debits
      Transaction.where(user_id: id, type:'transfer').all
    end

    def favorite_food(nth)
      food_sort = purchase_debits.group_by {|t| t.item_id}.sort_by {|k,v| v.count }.reverse
      food_sort[0..nth-1].map do |t|
        {item: t[1][0].item, amount: t[1].count}
      end
    end

    def purchased_by_day
      records = purchase_debits.group_by {|t| t.created_at.strftime("%Y-%m-%d")}
      result = {}
      records.each do |k,v|
        result[k] = v.inject(0) {|sum, t| sum += t.amount; sum}
      end
      result
    end

    def credits
      Transaction.where(receiver: id).all
    end

    def self.attributes 
      ['message_id', 'email', 'student_id', 'name', 'member_type', 'credit', 'purchase_debit', 'transfer_debit']
    end
  end
end