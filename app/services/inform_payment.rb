module IssPay

  module Service
    class DeleteTransactions
      include Dry::Transaction

      step :find_user
      step :check_user_balance

      def find_transactions(message_id)
        user = User.find(message_id: message_id)
        transactions = Transaction.where(user_id: user.id).all
        if transactions.empty?
        else
          Success(transactions)
        end
      end

      def set_transcations_to_paid(transactions)
        db = IssPay::App.db
        db.transaction do
          transactions.each do |transaction|
            transaction.status = 1
            transaction.save
          end
        end
        Success(transactions)
      rescue
        Failure()
      end
    end
  end
end