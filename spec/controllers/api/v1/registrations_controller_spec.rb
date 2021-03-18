require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe '#create' do
    let(:user_json) {
      {
        "email": "test@test.fr",
        "password": "testfr",
        "password_confirmation": "testfr"
      }
    }

    let(:villager_json) {
      {
        "email": "villager@test.fr",
        "password": "testfr",
        "password_confirmation": "testfr",
        "role": "villager"
      }
    }

    let(:town_hall_json) {
      {
        "email": "town_hall@test.fr",
        "password": "testfr",
        "password_confirmation": "testfr",
        "role": "town_hall"
      }
    }

    let(:profile_json) {
      {
        "first_name": "Mme. / M.",
        "last_name": "Test"
      }
    }

    let(:town_hall_profile_json) {
      {
        "name": "Mairie de Test"
      }
    }

    context '#valid params: user' do
      before do
        post :create, params: {
          "user": user_json,
          "profile": profile_json
        }
      end

      let(:res_json) { JSON.parse(response.body) }

      it 'should create user' do
        expect(User.count).to eq(1)
      end

      it 'should log the user in' do
        expect(res_json['logged_in']).to be true
        expect(response).to have_http_status(201)
      end

      it 'should create session' do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'should send back the right user informations' do
        expect(res_json['user']['email']).to eq('test@test.fr')
      end
    end

    context '#valid params: villager' do
      before do
        post :create, params: {
          user: villager_json,
          profile: profile_json
        }
      end

      let(:res_json) { JSON.parse(response.body) }

      it 'should create user' do
        expect(User.count).to eq(1)
      end

      it 'should log the user in' do
        expect(res_json['logged_in']).to be true
        expect(response).to have_http_status(201)
      end

      it 'should create session' do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'should send back the right user informations' do
        expect(res_json['user']['email']).to eq('villager@test.fr')
      end
    end

    context '#valid params: town_hall' do
      before do
        post :create, params: {
          user: town_hall_json,
          town_hall_profile: town_hall_profile_json
        }
      end

      let(:res_json) { JSON.parse(response.body) }

      it 'should create user' do
        expect(User.count).to eq(1)
      end

      it 'should log the user in' do
        expect(res_json['logged_in']).to be true
        expect(response).to have_http_status(201)
      end

      it 'should create session' do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'should send back the right user informations' do
        expect(res_json['user']['email']).to eq('town_hall@test.fr')
      end
    end

    context '#invalid params' do
      before do
        post :create, params: {
          user: user_json,
          profile: profile_json
        }
      end

      after(:each) do
        expect(response).to have_http_status(422)
      end

      context 'general' do
        it 'wrong json' do
          post :create, params: {
            user: {
              name: 'Test'
            }
          }
        end

        it 'email already used' do
          post :create, params: {
            user: user_json,
            profile: profile_json
          }
        end

        it 'wrong password confirmation' do
          post :create, params: {
            user: {
              "email": "test@test.fr",
              "password": "testfr",
              "password_confirmation": "wrong_pass"
            },
            profile: profile_json
          }
        end
      end

      context 'wrong json' do
        it 'town_hall user with villager profile' do
          post :create, params: {
            user: town_hall_json,
            profile: profile_json
          }
        end

        it 'villager user with town_hall profile' do
          post :create, params: {
            user: villager_json,
            town_hall_profile: town_hall_profile_json
          }
        end
      end
    end
  end
end