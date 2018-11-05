require 'roda'

module IssPay
  
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: './app/assets'
    plugin :json
    plugin :all_verbs
    plugin :multi_route


    route do |routing|
      
      routing.root do
        { "message" => "ISS Pay Api is running." }
      end

      routing.on 'api' do
        routing.on 'v1' do
          
          routing.multi_route
        end
      end

      routing.on 'item' do
        routing.route('item')
      end
    end
  end
end