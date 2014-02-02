
class Logman
  class Bucket
    include Mongoid::Document
    store_in collection: 'logman_buckets'
    
    attr_protected :write_token
    validates_presence_of :name
    validates_format_of :name, with: /[A-Za-z0-9_]+/
    
    field :name, type: String
    field :write_token,type: String
    field :user_ids, type: Array
    
    #collection specifications     
    def self.set_bucket_collection(name)
      Thread.current[:bucket_key] = name
    end
    
    def logs
      Bucket.set_bucket_collection(self.bucket_key)
      Log.all
    end
    #end
    
    def user_ids=(val)
      val = val.map {|key| Moped::BSON::ObjectId.from_string(key) }
      write_attribute(:user_ids, val)
    end
    
    def users
      User.where(:id.in => :user_ids)
    end
    
    def bucket_key
      key = self.name.gsub(' ','_').gsub('-','_')
      "bucket_#{key.underscore}"
    end
    
    before_create :new_token
    def new_token
      self.write_token = generate_new_token
    end
    
    def generate_new_token
      while true
        token = SecureRandom.hex
        return token if Bucket.where(:write_token=> token).count == 0
      end
    end

    def serializable_hash(options={})
      options[:methods] ||= [:id]
      super(options)
    end
  end
end