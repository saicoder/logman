
module Logman
  class Auth < ConsoleBase
    get '/login' do
      erb :login, locals:{ :invalid=> false, :register=> (User.count==0) }
    end
    
    post '/login' do
      #register for the first time
      if User.count == 0
        user = User.new(params)
        user.admin = true
        
        if user.save
           session[:user_id] = user.id.to_s
           return redirect '/'
        else
           return  erb :login, locals:{ :invalid=> true, :register=>true }
        end
      end       
      
      #login routine       
      user = User.find_by_email(params[:email])
     
      if user.nil? || user.authenticate(params[:password]).blank?
        erb :login, locals:{ :invalid=> true, :register=>false }
      else
        session[:user_id] = user.id.to_s
        redirect '/'
      end
    end
    
    get '/logout' do
      session[:user_id] = nil
      redirect '/'
    end
    
  end
end