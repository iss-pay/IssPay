module IssPay
  
  class App < Roda
    route('users') do |routing|
      routing.on 'login' do
        routing.post do
          user = User.find(email: routing.params['email'])
          session['current_user'] = user.id
          routing.redirect '/'
        end
      end



      routing.on 'logout' do
        routing.get do
          session['current_user'] = nil
          routing.redirect '/'
        end
      end      
    end
  end
end