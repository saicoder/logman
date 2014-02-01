

module Logman
  class User
    include Mongoid::Document
    self.collection_name = 'logman_users'

    has_secure_password :validations=>false
    
    validates_presence_of :email, :name
    validates_presence_of :password, :on=> :create
    validates_uniqueness_of :email
    validates_format_of :email, with: /.+\@.+\..+/
    
    field :email, type: String
    field :password_digest, type: String
    field :name, type: String 
    field :admin, type: Boolean
    
    # buckets that user have access     
    def buckets
      return Bucket.all if self.admin
      
      Bucket.where(:user_ids=> self.id)
    end
    
    def serializable_hash(options={})
      options[:except] ||= [:password_digest]
      super(options)
    end
    
    
  end
end