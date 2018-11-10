module IssPay

  class Item < Sequel::Model(:items)
    many_to_many :purchasers, class: 'IssPay::User',
                  join_table: :transactions,
                  left_key: :item_id, right_key: :user_id

    def self.attributes
      ['name', 'quantity', 'price', 'cost', 'image', 'category']
    end

    def self.drinks
      where(category: 'Drink').all
    end

    def self.snacks
      where(category: 'Snack').all    
    end

    def quantity_(method)
      
      if method == 'purchase'
        self.quantity = self.quantity - 1
        self.save
      elsif method == 'refund'
        self.quantity = self.quantity + 1
        self.save
      end
    end
  end
end