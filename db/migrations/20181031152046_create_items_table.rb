require 'sequel'

Sequel.migration do
  change do
    create_table :items do
      primary_key :id

      Strng :item_name
      String :category
      String :image_url
      
      Integer :quantity
      Integer :price
      
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end