require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'SESSION #create' do
    context '#valid params' do
      before do
        create(:user)
        
        post :create, params: {
          user: attributes_for(:user)
        }
      end

      it 'should log the user in' do
        res_json = JSON.parse(response.body)

        expect(res_json['logged_in']).to be true
        expect(response).to have_http_status(201)
      end

      it 'should create session' do
        expect(session[:user_id]).to eq(User.last.id)
      end
    end

    context '#invalid params' do
      before do
        create(:user)
      end

      after(:each) do
        expect(response).to have_http_status(422)
      end

      it 'wrong json' do
        post :create, params: {
          user: { name: "nothing" }
        }
      end

      it 'account not created' do
        post :create, params: {
          user: {
            email: "wrong@email.test",
            password: "testfr"
          }
        }
      end

      it 'wrong password' do
        post :create, params: {
          user: attributes_for(:user, password: "wrong_password")
        }
      end
    end
  end

  describe 'SESSION #logged_in' do
    context '# valid params' do
      before do
        create(:user)
        
        post :create, params: {
          user: attributes_for(:user)
        }

        get :logged_in
      end

      let(:res_json) { JSON.parse(response.body) }
      
      it 'should tell the user is logged in' do
        expect(response).to have_http_status(200)
        expect(res_json['logged_in']).to be true
      end

      it 'should render the user json' do
        expect(res_json['user']['email']).to eq(User.last.email)
        expect(res_json['user']['id']).to eq(session[:user_id])
      end
    end

    context '# not clogged_in' do
      before do
        get :logged_in
      end

      let(:res_json) { JSON.parse(response.body) }

      it 'should return not logged in' do
        expect(response).to have_http_status(200)
        expect(res_json['logged_in']).to be false
      end
    end
  end

  describe 'SESSION #logout' do
    before do
      create(:user)
        
      post :create, params: {
        user: attributes_for(:user)
      }

      delete :logout
    end

    let(:res_json) { JSON.parse(response.body) }

    it 'should send a response' do
      expect(response).to have_http_status(200)
      expect(res_json['status']).to eq(200)
      expect(res_json['logout']).to be true
    end
  end
end