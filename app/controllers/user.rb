module IssPay
  
  class App < Roda
    route('user') do |routing|
      routing.on 'login' do
        routing.post do
          routing.params
          user = User.find(email: routing.params['email'], member_type: routing.params['member_type'])
          session['current_user'] = user.id
          routing.redirect '/'
        end
      end

      routing.on 'list' do
        routing.get do
          @users = User.order(:member_type)
          view 'user/list', locals: {users: @users}
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