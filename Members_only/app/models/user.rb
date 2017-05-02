class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,     presence: true, length: { maximum: 30 }
  validates :email,    presence: true, length: { maximum: 50 },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { in: 6..20 }
  
  # CLASS METHODS:
    # Returns the hash digest of the given string, it means a secure string:
    def User.digest(string)    # This is a class method.
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token for remember attribute:
    def User.new_token  # This is a class methods.
      SecureRandom.urlsafe_base64
    end
  
  # INSTANCE METHODS:
    # Remembers a user in the database for use in persistent sessions and returns a secure remember token attriute:
    def create_remembertoken
      self.remember_token = User.new_token # self in this statement means an instance method of User class.
      update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Retruns true if the given token matches the digest:
    def authenticated?(remembertoken)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remembertoken)
    end
    
    # Forgets a user or elimiate the remember token:
    def forget_remembertoken
      update_attribute(:remember_token, nil)
    end
end
