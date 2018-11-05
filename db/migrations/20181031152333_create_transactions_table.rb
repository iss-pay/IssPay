require 'sequel'

Sequel.migration do
  change do
    create_table :transactions do
      primary_key :id
      foreign_key :user_id, table: :users
      foreign_key :item_id, table: :items
      foreign_key :receiver, table: :users
      
      String :type
      Integer :amount

      DateTime :created_at
    end
  end
end