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
        end
      end

      routing.root do
        @controller = 'home'
        view 'home', locals: { current_user: @current_user,}
      end

      routing.on 'item' do
        @controller = 'item'
        routing.post do
          item = Item.create(routing.params)
          item_amount = Item.where(category: routing.params['category']).all.count
          {
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            image_url: item.image_url,
            category: item.category,
            amount: item_amount
          }
        end
        routing.on String do |item_id|
          routing.put do
            item = Item.find(id: item_id)
            item.update(routing.params)
            item.save 
            routing.params
          end
        end
      end

      routing.on 'items' do
        @controller = 'item'
        routing.get do
          @item = Item
          view 'item/items', locals: {item: @item}
        end
      end

      routing.on 'user' do
        @controller = 'user'
        routing.route('user')
      end

      routing.on 'users' do
        routing.route('users')
      end

      routing.on 'transaction' do
        
      end

      routing.on 'chart' do
        routing.route('chart')
      end
    end
  end
end