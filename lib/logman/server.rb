


module Logman
   class Server < Sinatra::Base
     use Logman::Config.instance.log_writer if Logman::Config.instance.log_writer
     use Logman::Config.instance.web_console if Logman::Config.instance.web_console
   end
end
