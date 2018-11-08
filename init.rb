require 'hirb'
require 'pry'

folders = %w[config app lib]

folders.each do |folder|
  require "./#{folder}/init.rb"
end

include IssPay
# Hirb.enable

# old_print = Pry.config.print
# Pry.config.print = proc do |*args|
#   Hirb::View.view_or_page_output(args[1]) || old_print.call(*args)
# end

VIC = '1277419499034510'
# BOT = FbMessenger::Bot::Sender.new(VIC)
# ITEMS = Item.where(category: 'Drink').all[0..5]
# MENU = Representer::Menu.new(ITEMS, VIC)
# BOT.elements = MENU.to_json

DATA = {"message_id" => VIC, "category" => "Drink", "page" => "1", "response_type" => 'chatbot_msg'}