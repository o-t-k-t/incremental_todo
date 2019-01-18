class Task < ApplicationRecord
  include AASM

  # アソーシエーション設定
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels, source: :label, inverse_of: :tasks

  has_many_attached :attachments

  # 各フィールドのバリデーション
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  validates_datetime :deadline, after: -> { Time.zone.now }, allow_blank: true

  validate :requre_attachment_size_within_limit

  enum priority: { low: 1, medium: 2, high: 3 }

  scope :labeled, ->(label_id) { joins(:labels).where(labels: { id: label_id }) }

  scope :delayed, lambda {
    where('deadline < ?', Time.zone.now + 3.days)
      .where(status: 'not_started')
      .or(Task.where(status: 'started'))
  }

  accepts_nested_attributes_for :labels,
                                allow_destroy: false,
                                update_only: false,
                                reject_if: proc { |a| a[:name].blank? }

  def self.ransackable_scopes(_auth_object = nil)
    %i[recent_page deadline_asc_page]
  end

  def save_and_put_labels(task_params, label_ids)
    Task.transaction do
      save!(task_params)

      label_ids.each do |lid|
        task_labels.create!(label_id: lid)
      end
    end
  end

  def update_and_fire_event(task_params, event)
    if event
      raise 'Unexpected status event' if acceptable_event_names.exclude?(event.to_sym)

      send(event)
    end
    update(task_params)
  end

  def acceptable_event_names
    aasm.events(permitted: true).map(&:name)
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

  private

  def requre_attachment_size_within_limit
    return unless attachments.attached?

    attachments.each do |a|
      if a.blob.byte_size > 2.megabyte
        a.purge
        errors.add(:attachments, I18n.t('errors.messages.file_too_large'))
      end
    end
  end
end
