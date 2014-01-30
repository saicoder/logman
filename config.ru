require 'logman'

Logman.configure do |config|
  config.database_uri = 'mongodb://localhost:5556/logman'
  config.log_writer = Logman::LogWriter
  config.web_console = Logman::WebConsole
end

run Logman::Server
