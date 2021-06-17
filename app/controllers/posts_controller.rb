class PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.where('title LIKE ?', "%#{params[:title]}%")
                 .joins(:category)
                 .where('categories.name LIKE ?', "%#{params[:category]}%")
                 .order(created_at: :desc)
                 .select(:id, :title, :img_url, :created_at, 'categories.name AS category_name')

    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    @post = @current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :img_url, :category_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
