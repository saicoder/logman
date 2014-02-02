require File.dirname(__FILE__) + '/base'
require File.dirname(__FILE__) + '/auth'

require File.dirname(__FILE__) + '/user_api'
require File.dirname(__FILE__) + '/bucket_api'
require File.dirname(__FILE__) + '/log_api'

class Logman
  class WebConsole < ConsoleBase
      set :public_folder, File.dirname(__FILE__) + '/static'
      set :views, File.dirname(__FILE__) + '/views'
      set :sessions => true
      
      use Logman::Auth
      use Logman::UserAPI
      use Logman::BucketAPI
      use Logman::LogAPI
      
      get '/', :auth => :user do
        erb :app, :locals=>{user: @user}
      end   
  end
  
end