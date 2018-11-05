module IssPay

  class App < Roda
    
    route('show_menu_gallery') do |routing|
      
      routing.on String do |category|
        
        routing.get do
          result = GetMenuGallery.call(category)
          result
        end
      end
    end
  end
end