class User < ApplicationRecord
  has_many :tasks
  has_secure_password

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates_email_format_of :email, message: 'is not looking good'
  validates :password_digest, presence: true
  validates :password, presence: true, length: { in: 6..20 }
  validates :password_digest, presence: true
end