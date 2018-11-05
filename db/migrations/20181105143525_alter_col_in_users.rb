require 'sequel'

Sequel.migration do
  change do
    alter_table(:users) do
      rename_column :name, :first_name
      add_column :last_name, String
    end
  end
end