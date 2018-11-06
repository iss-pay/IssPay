require 'roda'


module IssPay
  
  class App < Roda
    plugin :render, engine: 'erb', views: 'app/views'
    plugin :assets, css: 'style.css', js: ['main.js', 'chartkick.js'], path: 'app/assets'
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
                 {
                   "attachment":{
                     "type":"template",
                     "payload":{
                       "template_type":"generic",
                       "image_aspect_ratio": "square",
                       "elements":[
                         {
                           "title":"Chatfuel Rockets Jersey",
                           "image_url":"https://rockets.chatfuel.com/assets/shirt.jpg",
                           "subtitle":"Size: M",
                           "buttons":[
                             {
                               "type":"web_url",
                               "url":"https://rockets.chatfuel.com/store",
                               "title":"View Item"
                             }
                           ]
                         },
                         {
                           "title":"Chatfuel Rockets Jersey",
                           "image_url":"https://rockets.chatfuel.com/assets/shirt.jpg",
                           "subtitle":"Size: L",
                           "default_action": {
                             "type": "web_url",
                             "url": "https://rockets.chatfuel.com/store",
                             "messenger_extensions": true
                           },
                           "buttons":[
                             {
                               "type":"web_url",
                               "url":"https://rockets.chatfuel.com/store",
                               "title":"View Item"
                             }
                           ]
                         }
                       ]
                     }
                   }
                 }
               ]
             }
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

      routing.on 'chart' do
        routing.route('chart')
      end
    end
  end
end