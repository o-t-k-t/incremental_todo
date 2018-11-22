class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates_email_format_of :email, message: 'is not looking good'
  validates :password_digest, presence: true
  validates :password, presence: true, length: { in: 6..20 }
  validates :password_digest, presence: true

  before_destroy :require_administrator_existance

  scope :id_order, -> { order(:id) }
  scope :with_task, -> { left_joins(:tasks) }

  def self.count_by_id_and_name
    group('users.id', 'users.name', 'users.admin').count('tasks.id')
  end

  def self.authenticate_by(email, password)
    find_by(email: email.downcase)&.authenticate(password)
  end

  private

  def require_administrator_existance
    return unless admin
    return unless self.class.where(admin: true).count <= 1

    errors.add(:admin, 'を持つユーザは少なくとも1人登録する必要があります')
    throw :abort
  end
end
