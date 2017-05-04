class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,     presence: true, length: { maximum: 30 }
  validates :email,    presence: true, length: { maximum: 50 },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { in: 6..20 }, allow_nil: true
  
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
    # Activates an account.
    def activate
      update_columns(activated: true, activated_at: Time.zone.now)
    end
    
    # Remembers a user in the database for use in persistent sessions and returns a secure remember token attriute:
    def create_remembertoken
      self.remember_token = User.new_token # self in this statement means an instance method of User class.
      update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Forgets a user or elimiate the remember token:
    def forget_remembertoken
      update_attribute(:remember_token, nil)
    end
    
    # Sets the password reset attributes:
    def create_reset_digest
      self.reset_token = User.new_token
      update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    # Sends a password reset email:
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end
    
    # Returns true if a password reset has expired:
    def is_password_reset_expired?
      reset_sent_at < 2.hours.ago
    end
    
    # PRIVATE METHODS:
    private
    
    # Creates and assigns the activation token and digest:
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end
