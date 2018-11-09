require_relative './app.rb'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end
require_relative './routes/init.rb'
require_relative './web/init.rb'