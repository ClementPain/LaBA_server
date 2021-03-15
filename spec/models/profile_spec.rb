require 'rails_helper'

RSpec.describe Profile, type: :model do
  it "should create profile" do
    user = User.new(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr')
    user.profile = Profile.new(first_name: 'test', last_name: 'test')
    user.save

    expect(User.count).to eq(1)
    expect(user.profile.first_name).to eq('test')
    expect(Profile.count).to eq(1)
  end

  it "should not create profile: no user" do
    Profile.create(first_name: 'test', last_name: 'test')

    expect(Profile.count).to eq(0)
  end

  context 'check validations' do
    it 'should not create profile: user already taken' do
      user = User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr')
      profile1 =  Profile.create(first_name: 'test', last_name: 'test', user_id: user.id)
      profile2 =  Profile.create(first_name: 'test', last_name: 'test', user_id: user.id)

      expect(Profile.count).to eq(1)
    end

    it 'should not create profile: user is a town_hall' do
      user = User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr', role: 1)
      profile =  Profile.create(first_name: 'test', last_name: 'test', user_id: user.id)

      expect(Profile.count).to eq(0)
    end
  end
end


