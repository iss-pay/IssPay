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
          routing.multi_route('v1')

          routing.get do
            Representer::ChatBotMsg.new("歡迎來到IssPay").general_response
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

      routing.on 'items' do
        @controller = 'item'
        routing.route('items')
      end

      routing.on 'user' do
        @controller = 'user'
        routing.route('user')
      end

      routing.on 'users' do
        @controller = 'user'
        routing.route('users')
      end

      routing.on 'transaction' do
      
      end

      routing.on 'transactions' do
        routing.route('transactions')  
      end

      routing.on 'chart' do
        routing.route('chart')
      end
    end
  end
end