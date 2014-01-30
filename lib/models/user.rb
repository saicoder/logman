
require './lib/modules/secure_password'

module Logman
  class User
    include MongoMapper::Document
    
    
    set_collection_name 'logman_users'
    
    attr_accessible :email, :name, :admin, :password
    
    has_secure_password :validations=>false, :validations=>false
    
    key :email, String, :required=>true, :unique=>true, :format=> /.+\@.+\..+/
    key :password_digest, String #, :required=>true
    key :name, String, :required=>true
    key :admin, Boolean
    
    # buckets that user have access     
    def buckets
      return Bucket.where if self.admin
      
      Bucket.where(:user_ids=> self.id)
    end
    
    def serializable_hash(options={})
      options[:except] ||= [:password_digest]
      super(options)
    end
    
    
  end
end