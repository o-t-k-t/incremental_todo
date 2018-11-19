class Label < ApplicationRecord
  enum colors: %i[no_color gray red yellow green blue]

  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels, source: :task, inverse_of: :labels

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 2000 }
  validates :color, inclusion: { in: colors.keys }

end
