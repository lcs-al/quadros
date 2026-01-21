class Card < ApplicationRecord
  belongs_to :column, optional: true
  belongs_to :backlog, optional: true
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  enum card_type: { story: 0, task: 1, bug: 2 }
  enum priority: { low: 0, medium: 1, high: 2, critical: 3 }
  
  validates :title, :creator, presence: true
  validate :must_belong_to_column_or_backlog

  acts_as_list scope: [:column_id, :backlog_id]

  default_scope { where(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }

  def soft_delete
    remove_from_list
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
    add_to_list_bottom
  end

  private

  def must_belong_to_column_or_backlog
    if column_id.blank? && backlog_id.blank?
      errors.add(:base, 'Card must belong to a column or a backlog')
    elsif column_id.present? && backlog_id.present?
      errors.add(:base, 'Card cannot belong to both a column and a backlog')
    end
  end
end

