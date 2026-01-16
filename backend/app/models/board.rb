class Board < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :columns, -> { order(position: :asc) }, dependent: :destroy
  has_many :cards, through: :columns

  validates :title, presence: true
end

