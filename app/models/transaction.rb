module IssPay
  
  class Transaction < Sequel::Model(:transactions)

    def item
      Item.find(id: item_id)
    end

    def before_create
      self.created_at ||= Time.now
    end    

    def after_save
      if self.type == 'purchase'
        purchase_with('create')
      elsif self.type == 'transfer'
        transfer_with('create')
      end
    end

    def after_destroy
      if self.type == 'purchase'
        purchase_with('destroy')
      elsif self.type == 'transfer'
        transfer_with('destroy')
      end
    end

    private

    def purchase_with(method)
      item = Item.find(id: self.item_id)
      user = User.find(id: self.user_id)
      if method == 'create'
        item.quantity -= 1
        user.purchase_debit -= item.price
      elsif method == 'destroy'
        item.quantity += 1
        user.purchase_debit += item.price
      end
      item.save
      user.save
    end

    def transfer_with(method)
      user = User.find(id: self.user_id)
      receiver = User.find(id: self.receiver)
      if method == 'create'
        receiver.credit += self.amount
        user.transfer_debit -= self.amount
      elsif method == 'destroy'
        receiver.credit -= self.amount
        user.transfer_debit += self.amount  
      end
      user.save
      receiver.save
    end
  end
end