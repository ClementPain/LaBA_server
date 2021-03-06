class User < ApplicationRecord
  enum role: [:villager, :town_hall], _default: :villager

  has_secure_password
  
  validates :email,
    uniqueness: true, presence: true,
    length: { in: 8..80, message: 'email length should be between 8 and 80 characters' },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'email format is incorrect' }

  validates :password, length: { in: 6..40 }

  has_one :profile, dependent: :destroy
  has_one :town_hall_profile, dependent: :destroy
end
