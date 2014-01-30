require 'mongo_mapper'
require 'sinatra'
require "sinatra/json"

require  File.dirname(__FILE__) +'/../modules/secure_password'

# models
require File.dirname(__FILE__) + '/../models/user'
require File.dirname(__FILE__) + '/../models/bucket'
require File.dirname(__FILE__) + '/../models/log'

# modules
require File.dirname(__FILE__) + '/../modules/log_writer'
require File.dirname(__FILE__) + '/../console/web_console'

module Logman
  class Config
      attr_accessor :log_writer
      attr_accessor :web_console
      
      def database_name
        MongoMapper.database
      end
      
      def database_name=(val)
        MongoMapper.database = val
      end
      
      def database_connection
        MongoMapper.connection
      end
      
      def database_uri=(uri)
        MongoMapper.connection = Mongo::Connection.from_uri(uri)
        MongoMapper.database = MongoMapper.connection.db.name
      end
      
      attr_accessor :logman_endpoin
    
      
      @@instance = nil
      def self.instance
        @@instance = Config.new if @@instance.nil?
        @@instance
      end
  end
  
  def self.configure(&block)
      block.call Logman::Config.instance
      
      require File.dirname(__FILE__) + '/../logman/server'
  end
end