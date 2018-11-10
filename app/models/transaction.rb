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
        item.quantity_('purchase')
      end
    end

    def after_destroy
      if type == 'purchase'
        item.quantity_('refund')
      end
    end

    def paid?
      self.status == 1
    end

  end
end