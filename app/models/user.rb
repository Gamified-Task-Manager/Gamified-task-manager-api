class User < ApplicationRecord
  has_secure_password
  
  belongs_to :theme, optional: true
  belongs_to :avatar, class_name: 'Reward', foreign_key: 'avatar_id', optional: true

  has_many :tasks, dependent: :destroy
  has_many :user_rewards, dependent: :destroy
  has_many :rewards, through: :user_rewards

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  # app/models/user.rb
def award_points!(amount)
  return if amount.to_i <= 0
  increment!(:points, amount)
end

end
