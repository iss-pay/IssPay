require 'sequel'

Sequel.migration do
  change do
    alter_table(:transactions) do
      drop_foreign_key :receiver
      add_foreign_key :receiver_id, :users
    end

    alter_table(:items) do
      add_column :cost, Integer
    end
  end
end