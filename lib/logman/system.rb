

class Logman
  class Config < Hash
    
      attr_accessor :log_writer
      
      #logman as webconsole and api       
      attr_accessor :web_console
      attr_accessor :database_config
      
      # logman as proxy      
      attr_accessor :logman_endpoin
      attr_accessor :write_token
      attr_accessor :public_endpoint
      
      def initialize
        @log_writer = Logman::LogWriter
        @web_console = Logman::WebConsole
        
        @database_config = './database.yaml' 
      end
      
        
      @@instance = nil
      def self.instance
        @@instance = Config.new if @@instance.nil?
        @@instance
      end
  end
  
  def self.env
    en = ENV['RACK_ENV'] || 'production'
    en.to_sym
  end
  
  def self.configure(&block)
      block.call Logman::Config.instance if block
      
      Mongoid.load!(Logman::Config.instance.database_config, Logman.env)
      
      require File.dirname(__FILE__) + '/../logman/server'
  end
end