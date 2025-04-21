class Task < ApplicationRecord
  belongs_to :user

  VALID_STATUSES = %w[pending in_progress completed].freeze
  VALID_PRIORITIES = %w[low medium high].freeze

  before_validation :downcase_priority, :downcase_status
  before_save :update_completed_flag

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :status, inclusion: { in: VALID_STATUSES }
  validates :priority, inclusion: { in: VALID_PRIORITIES }
  validates :points_awarded, numericality: { greater_than_or_equal_to: 0 }

  scope :incomplete, -> { where(completed: false) }

  private

  def update_completed_flag
    if status_changed? && status == "completed"
      self.completed = true
    elsif completed?
      # Lock it: prevent rollback by forcing status to stay "completed"
      self.status = "completed"
    end
  end

  def downcase_status
    self.status = status.downcase if status.present?
  end

  def downcase_priority
    self.priority = priority.downcase if priority.present?
  end

def calculate_points
  base = 10
  bonus = 0

  if due_date.present? && completed_at.present? && completed_at < due_date
    bonus += 5
  end

  case priority
  when 'medium'
    bonus += 3
  when 'high'
    bonus += 5
  end

  base + bonus
end
end
