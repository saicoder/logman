module Logman
  class Log
    include Mongoid::Document
    
    belongs_to :bucket
    validates_presence_of :log_type, :message
    
    field :log_type, type: Integer  #1-error, 2-success, 3-warning, 4-info
    field :data_type, type: String  #application that generated log like syslog,
    
    field :message, type: String          #short string message
    field :data, type: Hash
    
    field :datetime, Time
    
    embeds_many :sources, :class_name=>'Logman::Source'
    
    def self.count_on_date(date)
      begin
        # raise date.to_s
        start_time = Time.new(date.year, date.month, date.day, 0,0,0).utc
        end_time   = Time.new(date.year, date.month, date.day+1, 0,0,0).utc
        
        Log.where(:created_at => { :$gte => start_time }).where(:created_at => { :$lt  => end_time   }).count
      rescue
        0
      end
    end
    
    timestamps!
  end
  
  
  class Source
    include Mongoid::Document
    embedded_in :log, :class_name=>'Logman::Log'
    
    field :name, type: String
    field :ip_address, type: String
    field :hop, type: Integer
  end
end