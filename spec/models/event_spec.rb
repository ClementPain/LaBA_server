require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'should create event' do
    event = Event.new()

    expect(Event.count).to eq(0)
  end
end