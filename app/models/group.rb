class Group < ApplicationRecord
  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships, source: :user, inverse_of: :groups

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  def owner
    memberships.ownership.first.user
  end
end
