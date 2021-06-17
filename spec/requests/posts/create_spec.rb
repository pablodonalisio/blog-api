require 'rails_helper'

RSpec.describe 'POST /posts', type: :request do
  let!(:user) { User.create({ email: 'test@test.com', password: 'asdfgh' }) }
  let!(:token) do
    post '/auth/login', params: {
      email: user.email,
      password: 'asdfgh'
    }
    json = JSON.parse(response.body).deep_symbolize_keys
    json[:token]
  end
  let!(:category) { Category.create({ name: 'Science' })}

  it 'creates a new post' do
    post posts_path,
         params: {
           post: {
             title: 'Test',
             img_url: 'http://placeimg.com/640/480',
             content: 'Test',
             category_id: category.id
           }
         },
         headers: {
           authorization: "Bearer #{token}"
         }

    expect(response).to have_http_status(201)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:title]).to eq('Test')
    expect(json[:img_url]).to eq('http://placeimg.com/640/480')
    expect(json[:content]).to eq('Test')
    expect(json[:category_id]).to eq(category.id)
    expect(Post.last.title).to eq('Test')
  end

  scenario 'empty title' do
    post posts_path,
         params: {
           post: {
             title: '',
             img_url: 'http://placeimg.com/640/480',
             content: 'Test',
             category_id: category.id
           }
         },
         headers: {
           authorization: "Bearer #{token}"
         }

    expect(response).to have_http_status(422)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:title]).to include("can't be blank")
  end

  describe 'title already taken' do
    let!(:post_test) do
      Post.create(
        {
          title: 'Test',
          content: 'test',
          img_url: '',
          category_id: category.id,
          user_id: user.id
        }
      )
    end
    it "returns 'title already taken'" do
      post posts_path,
           params: {
             post: {
               title: 'Test'
             }
           },
           headers: {
             authorization: "Bearer #{token}"
           }

      expect(response).to have_http_status(422)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:title]).to include('has already been taken')
    end
  end
end