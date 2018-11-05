require 'sequel'

Sequel.migration do
  change do
    create_table :users do
      primary_key :id

      String :student_id
      String :email
      String :message_id
      
      String :name
      String :member_type
      
      String :password_hash
      String :salt

      DateTime :created_at
      DateTime :updated_at
    end
  end
end