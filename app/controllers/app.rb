require 'roda'


module IssPay
  
  class App < Roda
    plugin :render, engine: 'erb', views: 'app/views'
    plugin :assets, css: 'style.css', js: ['chartkick.js', 'application.js'], path: 'app/assets'
    plugin :json
    plugin :all_verbs
    plugin :multi_route


    route do |routing|
      
      routing.assets

      @current_user = session['current_user'].nil? ? nil : User.find(id: session['current_user']) 

      routing.on 'api' do
        routing.on 'v1' do
          
          routing.multi_route

          routing.get do
            {
              "messages": [
                {"text": "ISSPAY v1 API Running!"}
              ]
             }
          end
        end
        routing.on 'test' do
          routing.get do
          end
        end
      end

      routing.root do
        @controller = 'home'
        view 'home', locals: { current_user: @current_user,}
      end

      routing.on 'item' do
        @controller = 'item'
        routing.route('item')
      end

      routing.on 'user' do
        @controller = 'user'
        routing.route('user')
      end

      routing.on 'users' do
        routing.route('users')
      end

      routing.on 'chart' do
        routing.route('chart')
      end

      routing.on 'webhook' do
        routing.route('webhook')
      end
    end
  end
end