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
      end
    end
  end
end