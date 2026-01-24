class Column < ApplicationRecord
  belongs_to :board
  has_many :cards, -> { active.order(position: :asc) }, dependent: :destroy
  has_many :all_cards, class_name: 'Card', dependent: :destroy

  validates :title, presence: true

  acts_as_list scope: :board
end
