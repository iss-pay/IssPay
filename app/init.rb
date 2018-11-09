folders = %w[models values representers services controllers policies]

folders.each do |folder|
  require_relative "./#{folder}/init.rb"
end