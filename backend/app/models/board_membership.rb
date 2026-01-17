class BoardMembership < ApplicationRecord
  belongs_to :board
  belongs_to :user
  
  enum role: { viewer: 0, editor: 1 }
  
  validates :user_id, uniqueness: { scope: :board_id }
end
