require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should create User' do
    User.create(email: 'test@test.fr', password: 'testfr', password_confirmation: 'testfr')

    expect(User.count).to eq(1)
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
