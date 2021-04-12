require 'rails_helper'

RSpec.describe Api::V1::VillagesController, type: :controller do
  describe '#create' do

    context '#valid call' do
      before do
        create(:village)
        create(:village, name: "Testville01", zip_code: "00001", insee_code: "00001")
        create(:village, name: "Testville02", zip_code: "00002", insee_code: "00002")
        create(:village, name: "Testville3", zip_code: "00003", insee_code: "00003")
        create(:village, name: "Testville4", zip_code: "00004", insee_code: "00004")
        create(:village, name: "Testville5", zip_code: "00005", insee_code: "00005")
        create(:village, name: "Testville6", zip_code: "00006", insee_code: "00006")
        create(:village, name: "Testville7", zip_code: "00007", insee_code: "00007")
        create(:village, name: "Testville8", zip_code: "00008", insee_code: "00008")
        create(:village, name: "Testville9", zip_code: "00009", insee_code: "00009")
        create(:village, name: "Testville+", zip_code: "00010", insee_code: "00010")
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns 10 village name' do
        get :index
        expect(JSON.parse(response.body).length).to eq(10)
      end

      it 'returns villages with town name as keyword' do
        get :index, params: {
          "keyword": "Testville0"
        }

        res = JSON.parse(response.body)
        
        expect(res.length).to eq(2)
        expect(res[0]['zip_code']).to eq('00001')
        expect(res[1]['name']).to eq('Testville02')
      end
      
      it 'returns villages with zip_code as keyword' do
        get :index, params: {
          "keyword": "00004"
        }

        res = JSON.parse(response.body)
        
        expect(res.length).to eq(1)
        expect(res[0]['name']).to eq('Testville4')
      end

      it 'returns villages with zip_code and town name as keyword' do
        get :index, params: {
          "keyword": "00004 - Testv"
        }

        res = JSON.parse(response.body)
        
        expect(res.length).to eq(1)
        expect(res[0]['name']).to eq('Testville4')
      end
    end
  end
end