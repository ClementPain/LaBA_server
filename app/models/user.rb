class User < ApplicationRecord
  enum role: [:villager, :town_hall]

  has_secure_password
  
  validates :email,
    uniqueness: true, presence: true,
    length: { in: 8..60, message: 'email length should be between 8 and 60 characters' },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'email format is incorrect' }

  validates :password, length: { in: 6..40 }


  has_one :profile, dependent: :destroy
  has_one :town_hall_profile, dependent: :destroy
end
