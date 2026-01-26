class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_secure_password
  has_one_attached :avatar

  enum role: { user: 0, admin: 1 }

  has_many :boards, foreign_key: :created_by_id, dependent: :destroy
  has_many :board_memberships, dependent: :destroy
  has_many :accessible_boards, through: :board_memberships, source: :board
  has_many :assigned_cards, class_name: 'Card', foreign_key: :assignee_id
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def avatar_url
    return unless avatar.attached?

    avatar.url(expires_in: 1.hour)
  end

  def as_json(options = {})
    super(options.merge(methods: :avatar_url))
  end
end
