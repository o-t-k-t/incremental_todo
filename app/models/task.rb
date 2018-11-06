class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  validates_datetime :deadline, after: -> { DateTime.current }, allow_blank: true

  scope :recent, -> { order('created_at desc') }
  scope :deadline_asc, -> { order('deadline asc') }
end
