class TownHallProfile < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :user_id, :message => "User can only have one Profile"
  validate :user_role

  private

  def user_role
    if self.user_id && !User.find(self.user_id).town_hall?
      errors.add(:user_id, "User must be a town_hall")
    end
  end
end
