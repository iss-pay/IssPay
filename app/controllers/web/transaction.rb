module IssPay

  class App < Roda
    route('transactions') do |routing|
      routing.get do
        view 'transaction/transactions'
      end
    end
  end
end