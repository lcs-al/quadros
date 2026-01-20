class Backlog < ApplicationRecord
  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  validates :board, presence: true, uniqueness: true
end
