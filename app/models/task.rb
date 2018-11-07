class Task < ApplicationRecord
  include AASM

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  validates_datetime :deadline, after: -> { DateTime.current }, allow_blank: true

  scope :recent, -> { order('created_at desc') }
  scope :deadline_asc, -> { order('deadline asc') }

  aasm column: 'status' do
    state :not_started, initial: true
    state :started
    state :completed

    event :start do
      transitions from: %i[not_started completed], to: :started
    end

    event :complete do
      transitions from: %i[not_started started], to: :completed
    end
  end
end
