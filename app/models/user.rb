class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

# ensure we only save lowercase email addressses to db
  before_save { self.email = email.downcase }

# constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
# fields
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String

# indexing
  index({ email: 1 }, { unique: true, name: "email_index"})

# validation criteria
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, 
  			format: { with: VALID_EMAIL_REGEX },
  			uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password
end
