class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

# ensure we only save lowercase email addressses to db
  before_save { self.email = email.downcase }
  before_save :encrypt_password
    
# constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  ROLES = %w[ admin owner user guest ]

  # attribute accessors
  attr_accessor :password, :password_confirmation
    
  # fields
  field :name, type: String
  field :email, type: String
  field :password_hash, type: String
  field :password_salt, type: String
  field :role, type: String
    
  # indexing
  index({ email: 1 }, { unique: true, name: "email_index"})
    
  # validation criteria
  validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }
  validates_confirmation_of :password
  #validates :role, inclusion: { in: ROLES }

    # authenticate 
    def self.authenticate (email, password)
        user = find_by(email: email)
        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
            user
        else
            nil
        end
    end

private
    # perform actual password encryption here 
    def encrypt_password
        if password.present?
            self.password_salt = BCrypt::Engine.generate_salt
            self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
    end
end
