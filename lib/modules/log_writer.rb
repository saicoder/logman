class Logman
  
  class LogWriter < Sinatra::Base
    post '/api/write' do
      json = JSON.parse(request.body.read) 
      bucket = Bucket.where(:write_token=>params[:key]).first
      
      if bucket.nil?
        status 401
        return 'Invalid token' 
      end
      
      Bucket.set_bucket_collection bucket.bucket_key
      
      log = Log.new(json)
      log.datetime = Time.now if log.datetime.blank?
      
      if log.save
        return status 200
      else
        status 422
        log.errors.to_json
      end

    end
  end
 
end