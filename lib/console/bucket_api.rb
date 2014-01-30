module Logman
  class BucketAPI < ConsoleBase
    
    get '/api/buckets',:auth=>:user do
      json @user.buckets
    end
    
    get '/api/buckets/:id',:auth=>:user do
      json @user.buckets.find(params[:id])
    end
    
    post '/api/buckets', :auth=> :admin do
      json = JSON.parse(request.body.read) 
      bucket = Bucket.new(json)
      
      if bucket.save
        json bucket
      else
        status 422
        bucket.errors.to_json
      end
    end
    
    put '/api/buckets/:id', :auth=> :admin do
      if params[:generateToken].blank? == false
        bucket = Bucket.find(params[:id])
        bucket.new_token if bucket
        bucket.save
        return json bucket
      end
      
      json = JSON.parse(request.body.read) 
      bucket = Bucket.find(params[:id])
      
      if bucket.update_attributes(json)
        json bucket
      else
        status 422
        bucket.errors.to_json
      end
    end
    
    delete '/api/buckets/:id', :auth=>:admin do
      bucket = Bucket.find(params[:id])
      bucket.destroy if bucket
      status 200
    end
    
  end
end