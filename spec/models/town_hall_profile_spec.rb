require 'rails_helper'

RSpec.describe TownHallProfile, type: :model do
  it "should create profile" do
    user = User.new(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr', role: 1)
    user.town_hall_profile = TownHallProfile.new(name: 'Mairie de test')
    user.save

    expect(User.count).to eq(1)
    expect(user.town_hall_profile.name).to eq('Mairie de test')
    expect(TownHallProfile.count).to eq(1)
  end

  it "should not create profile: no user" do
    TownHallProfile.create(name: 'Mairie de test')

    expect(TownHallProfile.count).to eq(0)
  end

  context 'check validations' do
    it 'should not create profile: user already taken' do
      user = User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr', role: 1)
      profile1 =  TownHallProfile.create(name: 'Mairie de test', user_id: user.id)
      profile2 =  TownHallProfile.create(name: 'Mairie de test', user_id: user.id)

      expect(TownHallProfile.count).to eq(1)
    end

    it 'should not create profile: user is a town_hall' do
      user = User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr', role: 0)
      profile =  TownHallProfile.create(name: 'Mairie de test', user_id: user.id)

      expect(TownHallProfile.count).to eq(0)
    end
  end
end
