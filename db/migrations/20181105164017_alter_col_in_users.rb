require 'sequel'

Sequel.migration do
  change do
    alter_table(:users) do
      set_column_default :credit, 0
      set_column_default :purchase_debit, 0
      set_column_default :transfer_debit, 0
    end

    alter_table(:items) do
      set_column_default :quantity, 0
      set_column_default :price, 0  
    end
  end
end