module IssPay

  class App < Roda
    
    route('show_menu_gallery') do |routing|
      
      routing.get do
        result = GetMenuGallery.call('snack')
        result
      end
    end
  end
end