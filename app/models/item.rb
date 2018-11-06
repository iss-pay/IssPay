module IssPay

  class Item < Sequel::Model(:items)
    many_to_many :purchasers, class: 'IssPay::User',
                  join_table: :transactions,
                  left_key: :item_id, right_key: :user_id

    def self.attributes
      ['name', 'quantity', 'price', 'image', 'category']
    end

    def self.drinks
      where(category: 'Drink').all
    end

    def self.snacks
      where(category: 'Snack').all    
    end
  end
end