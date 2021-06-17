require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /auth/sign_up' do
    it 'creates a new user' do
      post '/auth/sign_up', params: {
        user: {
          email: 'test@test.com',
          password: 'asdfgh'
        }
      }
      expect(response).to have_http_status(201)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:email]).to eq('test@test.com')
      expect(User.last.email).to eq('test@test.com')
    end

    describe 'invalid email' do
      it 'returns invalid email' do
        post '/auth/sign_up', params: {
          user: {
            email: 'test',
            password: 'asdfgh'
          }
        }
        expect(response).to have_http_status(422)

        json = JSON.parse(response.body).deep_symbolize_keys

        expect(json[:errors]).to include('Email is invalid')
      end

      it "returns 'Email can\'t be blank'" do
        post '/auth/sign_up', params: {
          user: {
            email: '',
            password: 'asdfgh'
          }
        }
        expect(response).to have_http_status(422)

        json = JSON.parse(response.body).deep_symbolize_keys

        expect(json[:errors]).to include("Email can't be blank")
      end

      describe 'Email already taken' do

        let!(:user) { User.create({ email: 'test@test.com', password: 'asdfgh' }) }

        scenario 'Email has already been taken' do

          post '/auth/sign_up', params: {
            user: {
              email: 'test@test.com',
              password: 'asdfgh'
            }
          }
          expect(response).to have_http_status(422)

          json = JSON.parse(response.body).deep_symbolize_keys

          expect(json[:errors]).to include('Email has already been taken')
        end
      end
    end

    describe 'invalid password' do
      it "returns 'Password is too short'" do 
        post '/auth/sign_up', params: {
          user: {
            email: 'test@test.com',
            password: 'asdf'
          }
        }
        expect(response).to have_http_status(422)

        json = JSON.parse(response.body).deep_symbolize_keys

        expect(json[:errors]).to include('Password is too short (minimum is 6 characters)')
      end

      it "returns 'Password can\'t be blank'" do
        post '/auth/sign_up', params: {
          user: {
            email: 'test@test.com',
            password: ''
          }
        }
        expect(response).to have_http_status(422)

        json = JSON.parse(response.body).deep_symbolize_keys

        expect(json[:errors]).to include("Password can't be blank")
      end
    end
  end
end
