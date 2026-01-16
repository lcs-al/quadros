class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  has_secure_password
  has_one_attached :avatar

  enum role: { user: 0, admin: 1 }

  has_many :boards, foreign_key: :created_by_id, dependent: :destroy
  has_many :assigned_cards, class_name: 'Card', foreign_key: :assignee_id
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def avatar_url
    if avatar.attached?
      url_for(avatar)
    else
      nil
    end
  end
end

