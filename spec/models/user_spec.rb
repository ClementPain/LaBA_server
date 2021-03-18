require 'rails_helper'

RSpec.describe User, type: :model do
  context 'user creation' do
    it 'should create villager' do
      user = build(:user)

      expect(user.valid?).to be true
      expect(user.role).to eq("villager")
    end

    it 'should create town_hall' do
      user = build(:town_hall)

      expect(user.valid?).to be true
      expect(user.role).to eq("town_hall")
    end
  end

  context 'check validations' do 
    it 'should not create user : wrong email format' do
      user = build(:user, email: "test")

      expect(user.valid?).to be false
    end

    it 'should not create user : email already taken' do
      user1 = create(:user)
      user2 = build(:user)

      expect(user2.valid?).to be false
    end

    it 'should not create user : password' do
      user = build(:user, password: "t", password_confirmation: "t")

      expect(user.valid?).to be false
    end

    it 'should not create user : password_confirmation' do
      user = build(:user, password_confirmation: "testfr2")

      expect(user.valid?).to be false
    end
  end
end
