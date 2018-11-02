class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }
end
