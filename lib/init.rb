folders = %w[xlsx_importer FbMessenger]

folders.each do |folder|
  require_relative "#{folder}/init.rb"
end