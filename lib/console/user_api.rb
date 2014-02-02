class Logman
  class UserAPI < ConsoleBase
    
    get '/api/users',:auth=>:user do
      json User.all
    end
    
    get '/api/users/:id',:auth=>:user do
      json User.find(params[:id])
    end
    
    post '/api/users', :auth=> :admin do
      json = JSON.parse(request.body.read) 
      user = User.new(json)
      
      if user.save
        json user
      else
        status 422
        user.errors.to_json
      end
    end
    
    put '/api/users/:id', :auth=> :user do
      json = JSON.parse(request.body.read) 
      user = User.find(params[:id])
      
      if !@user.admin
         return 'invalid' if user.id != @user.id
         json['admin'] = false
      end
      puts json.inspect
      
      return 'One admin required' if @user.id == user.id && @user.admin && !json['admin'] && Logman::User.where(:admin=>true).count == 1
      
      if user.update_attributes(json)
        json user
      else
        status 422
        user.errors.to_json
      end
    end
    
    delete '/api/users/:id', :auth=>:admin do
      user = User.find(params[:id])
      user.destroy if user && user.id != @user.id
      status 200
    end
    
  end
end