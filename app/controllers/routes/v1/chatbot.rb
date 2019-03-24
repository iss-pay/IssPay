module IssPay

  class App < Roda

    route('create_transaction', 'v1') do |routing|
      routing.get do
        result = Service::CreateTransaction.new.call(routing.params)
        Representer::ChatBotMsg.transaction_response(result.success)
      end
    end

    route('delete_transaction', 'v1') do |routing|
      routing.on String do |transaction_id|
        transaction = Transaction.find(id: transaction_id)
        if transaction.destroy
          Representer::ChatBotMsg.send_text("成功取消購買")
        end
      end
    end

    route('pay_all_transactions', 'v1') do |routing|
      routing.on String do |message_id|
        result = Service::DeleteTransactions.new.call(message_id)
        if result.success?
          amount = result.success.map(&:amount).reduce(:+)
          Representer::ChatBotMsg.send_text("總共還款#{amount}元~~~")
        end
      end
    end
  end
end