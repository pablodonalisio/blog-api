require 'rails_helper'

RSpec.describe "DELETE /posts/:id", type: :request do
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

  it 'delete a post' do
    delete post_path(post_test),
           headers: {
             authorization: "Bearer #{token}"
           }

    expect(response).to have_http_status(204)
    expect(Post.find_by_title('Test').is_deleted).to eq(true)
  end
end
