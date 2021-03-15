class Profile < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user_id, message: "User can only have one Profile"
  validates_presence_of :user_id, message: "Profile must have a User"
  validate :user_role

  private

  def user_role
    if self.user_id && !User.find(self.user_id).villager?
      errors.add(:user_id, "User must be a villager")
    end
  end
end
