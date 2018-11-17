class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates_email_format_of :email, message: 'is not looking good'
  validates :password_digest, presence: true
  validates :password, presence: true, length: { in: 6..20 }
  validates :password_digest, presence: true

  before_destroy :requere_administrator_existance

  scope :id_order, -> { order(:id) }
  scope :with_task, -> { left_joins(:tasks) }

  def self.count_by_id_and_name
    group('users.id', 'users.name').count('tasks.id')
  end

  private

  def requere_administrator_existance
    if where(admin: false).count.zero?
      true
    else
      errors.add(:admin, 'を持つユーザは少なくとも1人登録する必要があります')
      false
    end
  end
end
