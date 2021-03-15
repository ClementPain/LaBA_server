require 'rails_helper'

RSpec.describe User, type: :model do
  context 'user creation' do
    it 'should create villager' do
      user = User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr')

      expect(User.count).to eq(1)
      expect(user.role).to eq("villager")
    end

    it 'should create town_hall' do
      user = User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr', role: 1)

      expect(User.count).to eq(1)
      expect(user.role).to eq("town_hall")
    end
  end

  context 'check validations' do 
    it 'should not create user : wrong email format' do
      User.create email:'test', password: 'testfr', password_confirmation: 'testfr'

      expect(User.count).to eq(0)
    end

    it 'should not create user : email already taken' do
      user1 = User.create email:'test@test.fr', password: 'testfr', password_confirmation: 'testfr'
      user2 = User.create email:'test@test.fr', password: 'testfr', password_confirmation: 'testfr'

      expect(User.count).to eq(1)
    end

    it 'should not create user : password' do
      User.create email:'test@test.fr', password: 't', password_confirmation: 't'

      expect(User.count).to eq(0)
    end

    it 'should not create user : password_confirmation' do
      User.create email:'test', password: 'testfr', password_confirmation: 'testfr2'

      expect(User.count).to eq(0)
    end
  end

  context 'profile association' do
    it 'should increment profile count' do
      user = User.new(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr')
      user.profile = Profile.new(first_name: 'test', last_name: 'test')
      user.save

      expect(User.count).to eq(1)
      expect(user.profile.first_name).to eq('test')
      expect(Profile.count).to eq(1)
    end
  end
end
