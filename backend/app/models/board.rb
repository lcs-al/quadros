class Board < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :columns, -> { order(position: :asc) }, dependent: :destroy
  has_many :cards, through: :columns
  has_one :backlog, dependent: :destroy
  has_many :board_memberships, dependent: :destroy
  has_many :members, through: :board_memberships, source: :user

  validates :title, presence: true

  after_create :create_backlog

  def owner?(user)
    created_by_id == user.id
  end

  def member?(user)
    owner?(user) || members.exists?(user.id)
  end

  def permission_level(user)
    return :owner if owner?(user)

    membership = board_memberships.find_by(user: user)
    membership&.role&.to_sym
  end

  private

  def create_backlog
    Backlog.create!(board: self)
  end
end
