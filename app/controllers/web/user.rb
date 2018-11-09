module IssPay
  
  class App < Roda
    route('user') do |routing|

      routing.on 'list' do
        routing.get do

        end
      end

      routing.on String do |user_id|
        routing.put do
          user = User.find(id: user_id)
          params = routing.params
          full_name = params.delete('full_name')
          params['last_name'] = full_name[0]
          params['first_name'] = full_name[1..-1]
          user.update(params)
          user.save
          routing.params
        end
      end
    end

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
      
      routing.get do
        @users = User.order(:member_type)
        view 'user/users', locals: {users: @users}
      end
    end
  end
end