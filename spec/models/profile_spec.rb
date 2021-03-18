require 'rails_helper'

RSpec.describe Profile, type: :model do
  it "should create profile" do
    user = create(:villager)
    profile = build(:profile, user: user)

    expect(user.profile.last_name).to eq('Test')
    expect(profile.valid?).to be true
  end

  context 'check validations' do
    it "should not create profile: no user" do
      profile = Profile.new(first_name: 'test', last_name: 'test')
  
      expect(profile.valid?).to be false
    end
    
    it 'should not create profile: user already taken' do
      profile1 = create(:profile)
      profile2 = build(:profile, user: profile1.user)

      expect(profile2.valid?).to be false
    end

    it 'should not create profile: user is a town_hall' do
      profile = build(:profile, user: create(:town_hall))

      expect(profile.valid?).to be false
    end
  end
end
