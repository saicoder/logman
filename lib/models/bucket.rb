
module Logman
  class Bucket
    include Mongoid::Document
    self.collection_name = 'logman_buckets'
    
    attr_protected :write_token
    validates_presence_of :name
    
    field :name, type: String
    field :write_token,type: String
    field :user_ids, type: Array
    
    has_many :logs, :class_name=>'Logman::Log'
    
    def user_ids=(val)
      val = val.map {|key| BSON::ObjectId(key) }
      write_attribute(:user_ids, val)
    end
    
    def users
      User.where(:id.in => :user_ids)
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