class Logman
  class Log
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    
    store_in collection: lambda { Thread.current[:bucket_key] }
    
    validates_presence_of :log_type, :message
    
    field :log_type, type: Integer  #1-error, 2-success, 3-warning, 4-info
    field :data_type, type: String  #application that generated log like syslog,
    field :message, type: String          #short string message
    field :data, type: Hash 
    field :datetime, type: Time
    
    embeds_many :sources, :class_name=>'Logman::Source'
    
    
    
    
    def self.count_on_date(date)
      # begin
        # raise date.to_s
        start_time = Time.new(date.year, date.month, date.day, 0,0,0).utc
        end_time   = start_time + 1.day
        
        count = 0
        
        Bucket.all.each do |b|
          count += b.logs.between(created_at: start_time..end_time).count
        end
        count
#         
      # rescue
        # 0
      # end
    end
    
    #to json     
    def serializable_hash(options={})
      options[:methods] ||= [:id]
      super(options)
    end
  end
  
  
  class Source
    include Mongoid::Document
    embedded_in :log, :class_name=>'Logman::Log'
    
    field :name, type: String
    field :ip_address, type: String
    field :hop, type: Integer
  end
end