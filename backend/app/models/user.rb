class User < ApplicationRecord
  has_secure_password

  enum role: { user: 0, admin: 1 }

  has_many :boards, foreign_key: :created_by_id, dependent: :destroy
  has_many :assigned_cards, class_name: 'Card', foreign_key: :assignee_id
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end

