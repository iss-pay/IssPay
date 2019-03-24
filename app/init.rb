folders = %w[models values representers services controllers]

folders.each do |folder|
  require_relative "./#{folder}/init.rb"
end