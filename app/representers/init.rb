require 'roar/decorator'
require 'roar/json'
require_relative 'chatbot/init'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end

