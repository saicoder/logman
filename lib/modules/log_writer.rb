module Logman
  
  class LogWriter < Sinatra::Base
    post '/api/write' do
      json = JSON.parse(request.body.read) 
      bucket = Bucket.find_by_write_token(params[:key])
      return 'Invalid token' if bucket.nil?
      
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