require 'simple_xlsx_reader'

class XlsxReader

  def initialize(file_path)
    @doc = SimpleXlsxReader.open(file_path)
  end

  def sheets
    @doc.sheets.map(&:name)
  end

  def sheet_to_table(sheet_name)
    sheet = @doc.sheets.select {|sheet| sheet.name == sheet_name}.first
    table_struct = Struct.new(:name, :content, :attributes)
    table_struct.new(sheet.name, parse_rows_to_hash(sheet.rows), sheet.rows[0])
  end

  def table_to_model(sheet_name)
    table = sheet_to_table(sheet_name)
    modle_name = table.name.chop.capitalize
    modle = Module.const_get("IssPay::#{modle_name}")
    table.content.map do |hash|
      modle.new(hash)
    end
  end

  private
  def parse_rows_to_hash(rows_array)
    attributes = rows_array[0]
    rows_array[1..-1].map do |row|
      result_hash = {}
      row.each_with_index do |val, index|
        result_hash.merge!({attributes[index] => formatting(val)})
      end
      result_hash
    end
  end

  def formatting(string)
    if string.include?(".0")
      string.to_i 
    else
      string
    end
  end
end