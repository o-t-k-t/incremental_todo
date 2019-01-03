class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_many :memberships, dependent: :delete_all
  has_many :groups, through: :memberships, source: :group, inverse_of: :users

  has_secure_password

  has_one_attached :avatar

  include Redis::Objects
  hash_key :alarming_tasks
  value :alarm_notified, expiration: 1.day
  lock :alarm_update
  # TODO: 定期更新処理のロックなのでExpireだけでロック解除させればシンプルになる。
  #       ただ、redis-objectsはlock_tryを未サポートで現状できない。

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates_email_format_of :email, message: 'is not looking good'
  validates :password, presence: true, length: { in: 6..20 }
  validates :password_digest, presence: true

  # 管理ユーザ最低1名の登録を維持するためのバリデーション処理
  before_destroy :require_administrator_existence
  before_update :require_admin_authority_existence

  scope :id_order, -> { order(:id) }
  scope :with_task, -> { left_joins(:tasks) }

  def self.count_by_id_and_name
    group('users.id', 'users.name', 'users.admin').count('tasks.id')
  end

  def self.authenticate_by(email, password)
    find_by(email: email.downcase)&.authenticate(password)
  end

  def read_task(task_id)
    alarming_tasks.delete(task_id)
    tasks.find(task_id)
  end

  def remove_task(task_id)
    alarming_tasks.delete(task_id)
    tasks.destroy(task_id)
  end

  # アラーム更新処理
  def alarm_initialize
    update_delayed_tasks_alarm { false }
  end

  def periodical_alarm_update
    update_delayed_tasks_alarm { |n| n }
  end

  private

  # アラーム更新テンプレート処理
  def update_delayed_tasks_alarm
    alarm_update_lock.lock do
      break if yield(alarm_notified.value)

      tasks.delayed.each { |t| alarming_tasks[t.id] = t.name }
      alarm_notified.value = true
    end
  end

  def require_administrator_existence
    return unless admin
    return if multiple_admin?

    errors.add(:admin, 'を持つユーザは少なくとも1人登録する必要があります')
    throw :abort
  end

  def require_admin_authority_existence
    return unless will_demote_from_admin?
    return if multiple_admins?

    errors.add(:admin, 'を持つユーザは少なくとも1人登録する必要があります')
    throw :abort
  end

  def will_demote_from_admin?
    admin == false && attribute_in_database(:admin) == true
  end

  def multiple_admins?
    self.class.where(admin: true).count > 1
  end
end
