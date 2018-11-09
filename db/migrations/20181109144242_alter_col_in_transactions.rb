require 'sequel'

Sequel.migration do
  change do
    alter_table(:transactions) do
      add_column :status, Integer, default: 0
    end

  end
end