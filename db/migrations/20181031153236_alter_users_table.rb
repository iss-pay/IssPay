require 'sequel'

Sequel.migration do
  change do
    alter_table(:users) do
      add_column :credit, Integer
      add_column :purchase_debit, Integer
      add_column :transfer_debit, Integer
    end
  end
end