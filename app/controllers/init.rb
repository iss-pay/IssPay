require_relative './app.rb'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end

require_relative './v1/init.rb'