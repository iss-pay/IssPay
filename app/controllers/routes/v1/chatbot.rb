module IssPay

  class App < Roda

    route('create_transaction', 'v1') do |routing|
      routing.get do
        result = Service::CreateTransaction.new.call(routing.params)
        Representer::ChatBotMsg.new(result.success).transaction_response
      end
    end

    route('delete_transaction', 'v1') do |routing|
      routing.on String do |transaction_id|
        transaction = Transaction.find(id: transaction_id)
        if transaction.destroy
          Representer::ChatBotMsg.new("成功取消購買").general_response
        end
      end
    end

    route('pay_all_transactions', 'v1') do |routing|
      routing.on String do |message_id|
        result = Service::DeleteTransactions.new.call(message_id)
        if result.success?
          amount = result.success.map(&:amount).reduce(:+)
          Representer::ChatBotMsg.new("總共還款#{amount}元~~~").general_response
        end
      end
    end

    route('inform_payment', 'v1') do |routing|
      routing.on String do |message_id|
        result = Service::InformPayment.new.call(message_id)
        if result.success?
          message = "月底到了，快還錢喔～～"
          text = ChatFuel::Text.new(message)
          ChatFuel::Message.new(text).to_json
        end
      end
    end
  end
end