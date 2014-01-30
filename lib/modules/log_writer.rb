module Logman
  
  class LogWriter < Sinatra::Base
    post '/api/write' do
      json = JSON.parse(request.body.read) 
      bucket = Bucket.find_by_write_token(params[:key])
      if bucket.nil?
        status 401
        return 'Invalid token' 
      end
      
      log = Log.new(json)
      log.datetime = Time.now if log.datetime.blank?
      log.bucket = bucket
      
      
      if log.save
        return status 200
      else
        status 422
        log.errors.to_json
      end

    end
  end
 
end