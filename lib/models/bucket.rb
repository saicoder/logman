
module Logman
  class Bucket
    include MongoMapper::Document
    set_collection_name 'logman_buckets'
    
    attr_accessible :name, :user_ids
    
    key :name, String, :required=>true
    key :write_token, String
    key :user_ids, Array
    
    many :users, :in => :user_ids, :class_name=>'Logman::User'
    
    many :logs, :class_name=>'Logman::Log'
    
    def user_ids=(val)
      val = val.map {|key| BSON::ObjectId(key) }
      write_attribute(:user_ids, val)
    end
    
    before_create :new_token
    
    def new_token
      self.write_token = generate_new_token
    end
    
    
    def generate_new_token
      while true
        token = SecureRandom.hex
        return token if Bucket.find_by_write_token(token).nil?
      end
    end

    
  end
end