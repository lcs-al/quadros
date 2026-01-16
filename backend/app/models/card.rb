class Card < ApplicationRecord
  belongs_to :column
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  validates :title, :creator, presence: true
  
  acts_as_list scope: :column
end

