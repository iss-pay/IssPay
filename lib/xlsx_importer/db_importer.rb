require_relative 'xlsx_reader'

class DBImporter

  def initialize(file_name)
    @db_xlsx = XlsxReader.new(file_name)
    @db = IssPay::App.db
  end

  def import(table_name)
    models = @db_xlsx.table_to_model(table_name)
    puts "There are #{models.length} data."
    @db.transaction do
      models.each do |model|
        model.save
      end
    end
    puts "All #{table_name.chop} data are imported into database."
  end

end