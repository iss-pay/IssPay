module IssPay
  
  class Transaction < Sequel::Model(:transactions)

    def item
      Item.find(id: item_id) unless item_id.nil?
    end

    def owner
      User.find(id: user_id)
    end
    
    def receiver
      User.find(id: receiver_id) unless receiver_id.nil?
    end

    def before_create
      self.created_at ||= Time.now
    end

    def after_create
      
      if type == 'purchase'
        purchased_item = Item.find(id: item_id)
        quantity = purchased_item.quantity
        purchased_item.quantity = quantity -1  
        purchased_item.save
      end
    end

    def paid?
      self.status == 1
    end

  end
end