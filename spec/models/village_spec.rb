require 'rails_helper'
require 'open-uri'
require 'nokogiri'

RSpec.describe Village, type: :model do
  describe '#create village' do
    it 'should create village' do
      village = build(:village)

      expect(village.valid?).to be true
    end

    context 'check validations' do 
      it 'should not create village : wrong email format' do
        village = build(:village, email: "test")

        expect(village.valid?).to be false
      end

      it 'should not create village : email already taken' do
        village1 = create(:village)
        village2 = build(:village)

        expect(village2.valid?).to be false
      end

      it 'should not create village : name too short' do
        village = build(:village, name: "a")

        expect(village.valid?).to be false
      end

      it 'should not create village : zip_code wrong format' do
        village1 = build(:village, zip_code: 00000)
        village2 = build(:village, zip_code: "123")

        expect(village1.valid?).to be false
        expect(village2.valid?).to be false
      end
    end
  end

  describe '#scrapping' do
    it 'should scrap village' do
      array = Village.test_scrapping("37", "mettray")

      expect(array[0]).to eq('37152')
      expect(array[1]).to eq('37390')
      expect(array[2]).to eq('dgs@ville-mettray.fr')
      expect(array[3]).to be true
    end

    it 'should return an error' do
      expect(Village.test_scrapping("37", "no_town")).to eq('url error')
    end
  end 
end
