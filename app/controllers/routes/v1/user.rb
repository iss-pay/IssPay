module IssPay

  class App < Roda
    
    route('user', 'v1') do |routing|
      
      routing.on String do |message_id|
        if routing.params['response_type'] == 'chatbot_msg'
          user = User.find(message_id: message_id)
          Representer::ChatBotMsg.new(user).send_balance
        else
        end
      end

      routing.post do
        puts routing.params
        data = {
          'message_id' => routing.params['messenger user id'],
          'last_name' => routing.params['last name'],
          'first_name' => routing.params['first name'],
          'member_type' => routing.params['MemberType']
        }
        user = User.find(message_id: data['message_id'])
        if !user.nil?
          Representer::ChatBotMsg.new("Hello #{user.first_name}，你已經註冊過了喔~~").general_response
        else
          user = User.create(data)
          Representer::ChatBotMsg.new("Hello #{user.first_name}，成功註冊為#{user.member_type}!!").general_response
        end
      end
    end
  end
end