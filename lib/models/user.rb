

class Logman
  class User
    include Mongoid::Document
    include ActiveModel::SecurePassword
    
    store_in collection: 'logman_users'
    
    attr_accessible :email, :password, :name, :admin
    
    validates_presence_of :email, :name
    validates_presence_of :password, :on=> :create
    validates_uniqueness_of :email
    validates_format_of :email, with: /.+\@.+\..+/
    
    field :email, type: String
    field :password_digest, type: String
    field :name, type: String 
    field :admin, type: Boolean
    
    has_secure_password
    
    # buckets that user have access     
    def buckets
      return Bucket.all if self.admin
      
      Bucket.where(:user_ids=> self.id)
    end
    
    
    def serializable_hash(options={})
      options[:methods] ||= [:id]
      options[:except] ||= [:password_digest]
      super(options)
    end
    
    
  end
end