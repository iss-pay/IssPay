module IssPay

  class App < Roda
    
    route('show_menu_gallery') do |routing|
      
      routing.on String do |category|

        routing.get do
          result = GetMenuGallery.call(category, routing.params['message_id'])
          result
        end
      end
    end
  end
end