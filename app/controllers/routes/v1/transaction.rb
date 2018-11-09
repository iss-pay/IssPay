module IssPay

  class App < Roda
    route('transaction', 'v1') do |routing|
      routing.get do
        {"test" => "test transaction."}
      end

      routing.post do
        result = Service::CreateTransaction.new.call(routing.params)
        if result.success?
          TransactionsRepresenter.new(Transactions.new(result.success)).to_json
        end
      end
    end
  end
end