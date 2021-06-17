require 'rails_helper'

RSpec.describe "PATCH /posts/:id", type: :request do
  let!(:user) { User.create({ email: 'test@test.com', password: 'asdfgh' }) }
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

  it 'updates a post title' do
    patch post_path(post_test),
          params: {
            post: {
              title: 'Change title'
            }
          },
          headers: {
            authorization: "Bearer #{token}"
          }

    expect(response).to have_http_status(200)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:title]).to eq('Change title')
    expect(Post.last.title).to eq('Change title')
  end

  scenario 'empty title' do
    patch post_path(post_test),
          params: {
            post: {
              title: ''
            }
          },
          headers: {
            authorization: "Bearer #{token}"
          }

    expect(response).to have_http_status(422)

    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:title]).to include("can't be blank")
  end
end
