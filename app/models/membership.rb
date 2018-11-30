class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum role: { general: 0, owner: 1 }

  validates :user, presence: true
  validates :group, presence: true
  validates :user, uniqueness: { scope: :group }
  validates :role, inclusion: { in: Membership.roles.keys }

  before_destroy :require_owner_existance

  scope :ownership, -> { where(role: :owner) }

  def self.create_with_group!(user, group)
    ActiveRecord::Base.transaction do
      group.save!
      group.memberships.create!(user: user, role: :owner)
    end
  end

  private

  def require_owner_existance
    return if role != 'owner'

    errors.add(:owner, 'はグループ所有者なのでやめられません')
    throw :abort
  end
end
