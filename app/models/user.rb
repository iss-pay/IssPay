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
      member_type.gsub(' ',"") == 'Admin'
    end

    def balance 
      credit - debit
    end

    def favorite_food(nth)
      food_sort = transactions('debit', 'purchase').group_by {|t| t.item_id}.sort_by {|k,v| v.count }.reverse
      food_sort[0..nth-1].map do |t|
        {item: t[1][0].item, amount: t[1].count}
      end
    end

    def purchased_by_day
      records = transactions('debit', 'purchase').group_by {|t| t.created_at.strftime("%Y-%m-%d")}
      result = {}
      records.each do |k,v|
        result[k] = v.inject(0) {|sum, t| sum += t.amount; sum}
      end
      result
    end

    def transactions(type, debit_type=nil)
      if type == 'debit'
        debit_type.nil? ? Transaction.where(user_id: id).all : Transaction.where(user_id: id, type: debit_type).all
      elsif type == 'credit'
        Transaction.where(receiver_id: id).all
      end
    end

    def debit(type=nil)
      if type.nil? || type == 'purchase'
        transactions = Transaction.where(user_id: id, status: 0).all
      elsif type == 'transfer'
        transactions = Transaction.where(user_id: id, type: type, status: 0).all
      end 
      sum_of_transactions(transactions)
    end

    def credit
      transactions = Transaction.where(receiver_id: id, status: 0)
      sum_of_transactions(transactions)
    end

    def self.attributes 
      ['message_id', 'email', 'student_id', 'name', 'member_type', 'credit', 'purchase_debit', 'transfer_debit']
    end

    private

    def sum_of_transactions(transactions)
      return 0 if transactions.empty?
      transactions.map(&:amount).reduce(:+)
    end
  end
end