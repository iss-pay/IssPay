module IssPay

  class App < Roda

    route('user', 'v1') do |routing|

      routing.on String do |message_id|
        if routing.params['response_type'] == 'chatbot_msg'
          user = User.find(message_id: message_id)
          Representer::ChatBotMsg.send_balance(user)
        else
        end
      end

      routing.post do
        puts routing.params
        data = {
          'message_id' => routing.params['messenger user id'],
          'last_name' => routing.params['last name'],
          'first_name' => routing.params['first name'],
          'member_type' => routing.params['member_type']
        }
        user = User.find(message_id: data['message_id'])
        if !user.nil?
          view 'chatfuel/text.json', locals: { texts:['hello'] }
        else
          user = User.create(data)
          view 'chatfuel/text.json', locals: { texts:['hello'] }
        end
      end
    end
  end
end