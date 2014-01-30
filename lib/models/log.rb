module Logman
  class Log
    include MongoMapper::Document
    belongs_to :bucket
    attr_accessible :log_type, :data_type, :message, :data, :datetime,:sources
    
    key :log_type, Integer, :required=>true  #1-error, 2-success, 3-warning, 4-info
    key :data_type, String #application that generated log like syslog,
    
    key :message, String, :required=>true #short string message
    key :data, Hash
    
    key :datetime, Time
    
    many :sources, :class_name=>'Logman::Source'
    
    def self.count_on_date(date)
      start_time = Time.new(date.year, date.month, date.day, 0,0,0).utc
      end_time   = Time.new(date.year, date.month, date.day+1, 0,0,0).utc
      
      Log.where(:created_at => { :$gte => start_time }).where(:created_at => { :$lt  => end_time   }).count
    end
    
    timestamps!
  end
  
  
  class Source
    include MongoMapper::EmbeddedDocument
    attr_accessible :name, :ip_address, :hop
    
    key :name, String
    key :ip_address, String
    key :hop, Integer, :default=>0
  end
end