require 'rails_helper'

RSpec.describe "GET /posts", type: :request do
  let!(:user) { User.create({ email: 'test@test.com', password: 'asdfgh' })}
  let!(:token) do
    post '/auth/login', params: {
      email: user.email,
      password: 'asdfgh'
    }
    json = JSON.parse(response.body).deep_symbolize_keys
    json[:token]
  end
  let!(:category) { Category.create({ name: 'test' }) }
  let!(:post_test) do
    Post.create(
      {
        title: 'Test',
        img_url: 'http://placeimg.com/640/480',
        content: 'Test',
        category_id: category.id,
        user_id: user.id
      }
    )
  end

  it 'shows all posts' do
    get posts_path,
        headers: {
          authorization: "Bearer #{token}"
        }

    expect(response).to have_http_status(200)

    json = JSON.parse(response.body)[0].deep_symbolize_keys
    expect(json[:title]).to eq('Test')
  end

  it 'returns posts with specified title' do
    get posts_path,
        params: {
          title: 'Te'
        },
        headers: {
          authorization: "Bearer #{token}"
        }

    expect(response).to have_http_status(200)

    json = JSON.parse(response.body)[0].deep_symbolize_keys
    expect(json[:title]).to eq('Test')
  end

  it 'returns posts with specified category' do
    get posts_path,
        params: {
          category: 'te'
        },
        headers: {
          authorization: "Bearer #{token}"
        }

    expect(response).to have_http_status(200)

    json = JSON.parse(response.body)[0].deep_symbolize_keys
    expect(json[:category_name]).to eq('test')
  end
end
