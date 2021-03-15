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

  it "should not create profile" do
    Profile.create(first_name: 'test', last_name: 'test')

    expect(Profile.count).to eq(0)
  end
end


