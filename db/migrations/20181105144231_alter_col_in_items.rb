require 'sequel'

Sequel.migration do
  change do
    alter_table(:items) do
      rename_column :item_name, :name
    end
  end
end