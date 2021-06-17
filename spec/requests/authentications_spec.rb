require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe 'POST /auth/login' do
    let!(:user) { User.create({ email: 'test@test.com', password: 'asdfgh' }) }

    scenario 'succesfully loged in' do
      post '/auth/login', params: {
        email: 'test@test.com',
        password: 'asdfgh'
      }

      expect(response).to have_http_status(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json).to include(:token, :exp)
      expect(json[:email]).to eq('test@test.com')
    end

    scenario 'unauthorized' do
      post '/auth/login', params: {
        email: '',
        password: 'asdfgh'
      }

      expect(response).to have_http_status(401)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:error]).to eq('unauthorized')
    end
  end
end
