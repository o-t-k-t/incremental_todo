class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  scope :recent, -> { order('created_at desc') }
end
