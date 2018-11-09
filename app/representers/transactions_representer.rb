require_relative 'transaction_representer'

module IssPay

  class TransactionsRepresenter < Roar::Decorator
    include Roar::JSON

    collection :transactions, extend: TransactionRepresenter
  end
end