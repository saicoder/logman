require 'mongo_mapper'
require 'sinatra'
require "sinatra/json"

# models
require './lib/models/user'
require './lib/models/bucket'
require './lib/models/log'

# modules
require './lib/modules/log_writer'
require './lib/console/web_console'

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
      
      require './lib/logman/server'
  end
end