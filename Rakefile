task :console do
  sh 'pry -r ./init.rb'
end

namespace :db do
  # rake db:create_migration[file_name]
  task :create_migration, [:name] do |taks, args| 
    TIMESTAMP = Time.now.strftime('%Y%m%d%H%M%S')
    sh "touch ./db/migrations/#{TIMESTAMP+"_"+args[:name]}.rb"
  end

  require 'sequel'
  require_relative './config/environments.rb'
  Sequel.extension :migration
  app = IssPay::App
  task :run_migration do
    Sequel::Migrator.run(app.db, 'db/migrations')
    puts "migration work"
  end

  task :run_importer do
    require_relative 'init'
    FILE_PATH = 'lib/xlsx_importer/excels/DB.xlsx'
    db_importer = DBImporter.new(FILE_PATH)
    db_importer.import('users')
    db_importer.import('items')
  end
end
