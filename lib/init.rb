folders = %w[xlsx_importer]

folders.each do |folder|
  require_relative "#{folder}/init.rb"
end