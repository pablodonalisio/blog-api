class PostsController < ApplicationController
  before_action :authorize_request

  def index
    @posts = Post.order(created_at: :desc).includes(:category)
    render json: @posts.as_json(
      only: %i[id title img_url created_at],
      include: { category: { only: :name } }
    )
  end

  def create
    @post = @current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :img_url, :category_id)
  end
end
