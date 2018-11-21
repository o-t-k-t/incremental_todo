class Task < ApplicationRecord
  include AASM

  # アソーシエーション設定
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels, source: :label, inverse_of: :tasks

  # 各フィールドのバリデーション
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  validates_datetime :deadline, after: -> { DateTime.current }, allow_blank: true

  enum priority: { low: 1, medium: 2, high: 3 }

  accepts_nested_attributes_for :labels,
                                allow_destroy: false,
                                update_only: false

  # 一覧表示のための検索処理
  scope :priority_height_page, ->(params) { order('priority desc').page(params[:page]) }
  scope :recent_page, ->(params) { order('created_at desc').page(params[:page]) }
  scope :deadline_asc_page, ->(params) { order('deadline asc').page(params[:page]) }

  scope :labeled, ->(label_id) { joins(:labels).where(labels: { id: label_id }) }

  def self.ransackable_scopes(_auth_object = nil)
    %i[recent_page deadline_asc_page]
  end

  # 進捗状態の遷移条件・処理の定義
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

  # ラベリング処理
  def put_label(label)
    task_labels.create!(label_id: label.id)
  end

  def peel_label(label)
    task_labels.where(label_id: label.id).first.destroy
  end
end
