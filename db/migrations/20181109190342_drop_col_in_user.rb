require 'sequel'

Sequel.migration do
  change do
    alter_table(:users) do
      drop_column :credit
      drop_column :purchase_debit
      drop_column :transfer_debit
    end
  end
end