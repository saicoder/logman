class Logman
  class ConsoleBase < Sinatra::Base
    before do
      # session[:user_id] = '52e7ffa1adf1744071000001'
      @user = User.find(session[:user_id]) if session[:user_id]
    end
     
     register do
        def auth (type)
          condition do
            if @user.nil?
              redirect "/login"
            else
              ut = (@user.admin)? :admin : :user
              halt 401, 'No Access' if ut == :user && type == :admin
            end
          end
        end
     end
    
  end
end