class Card < ApplicationRecord
  belongs_to :column
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  enum card_type: { story: 0, task: 1, bug: 2 }
  
  validates :title, :creator, presence: true
  
  acts_as_list scope: :column

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
end

