class Column < ApplicationRecord
  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  validates :title, presence: true

  acts_as_list scope: :board
end
