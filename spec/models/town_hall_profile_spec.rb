require 'rails_helper'

RSpec.describe TownHallProfile, type: :model do
  it "should create town hall profile" do
    user = create(:town_hall)
    profile = build(:town_hall_profile, user: user)

    expect(user.town_hall_profile.name).to eq('Mairie de Test')
    expect(profile.valid?).to be true
  end

  context 'check validations' do
    it "should not create profile: no user" do
      profile = TownHallProfile.new(name: 'Mairie de test')
  
      expect(profile.valid?).to be false
    end

    it 'should not create profile: user already taken' do
      profile1 = create(:town_hall_profile)
      profile2 = build(:town_hall_profile, user: profile1.user)

      expect(profile2.valid?).to be false
    end

    it 'should not create profile: user is a villager' do
      profile = build(:town_hall_profile, user: create(:villager))

      expect(profile.valid?).to be false
    end
  end
end
