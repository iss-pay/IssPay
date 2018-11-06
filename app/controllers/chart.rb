module IssPay

  class App < Roda
    
    route('chart') do |routing|
      
      routing.on String do |method|
        
        routing.get do
          if method == 'user_purchased'
            result = @current_user.purchased_by_day
          end
          result
        end
      end
    end
  end
end