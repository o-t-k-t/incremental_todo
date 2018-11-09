class Task < ApplicationRecord
  include AASM

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  validates_datetime :deadline, after: -> { DateTime.current }, allow_blank: true

  enum priority: { low: 1, medium: 2, high: 3 }

  scope :recent, -> { order('created_at desc') }
  scope :deadline_asc, -> { order('deadline asc') }
  scope :priority_height, -> { order('priority desc') }

  def self.ransackable_scopes(_auth_object = nil)
    %i[recent deadline_asc]
  end

  aasm column: 'status' do
    state :not_started, initial: true
    state :started
    state :completed

    event :start do
      transitions from: %i[not_started completed], to: :started
    end

    event :pend do
      transitions from: :not_started, to: :not_started
      transitions from: :started, to: :started
      transitions from: :completed, to: :completed
    end

    event :complete do
      transitions from: %i[not_started started], to: :completed
    end
  end
end
