module SecureUrl
  
  module ClassMethods
    def acts_as_secure_url
      before_validation_on_create :generate_salt, :generate_public_key, :generate_access_key
      
      validates_presence_of :public_key, :access_key, :salt
      validates_length_of :public_key, :within => 8..256
      validates_length_of :access_key, :is => 40
      validates_length_of :salt, :is => 40
      
      
      def sha1_digest(*args)
        Digest::SHA1.hexdigest(args.join("--"))
      end
      
      def random_hash
        Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand}--")
      end
      
      def authenticate(id, link_code)
        resource = find(id)
        resource && resource.authenticated?(link_code) ? resource : nil
      end
      
    end
  end
  
  module InstanceMethods
    def encrypt(arg)
      cypher = ""
      SecureUrl::HASH_ITERATIONS.times do
        cypher = self.class.sha1_digest(arg, salt, cypher, SecureUrl::SITE_KEY)
      end
      cypher
    end
    
    def authenticated?(public_key)
      access_key == encrypt(public_key)
    end
    
    def public_key_data
      self.class.random_hash
    end
    
    def generate_salt
      self.salt = self.class.random_hash
    end
    
    def generate_access_key
      self.access_key = encrypt(public_key)
    end
    
    def generate_public_key
      self.public_key = public_key_data
    end

    
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
