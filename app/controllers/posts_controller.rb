class PostsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render 'posts/show', status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.user == current_user && @post.update(post_params)
      render 'posts/show', status: :ok
    else
      render json: { error: "Não autorizado ou dados inválidos" }, status: :forbidden
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.destroy
      head :no_content
    else
      render json: { error: "Não autorizado" }, status: :forbidden
    end
  end

  private

  def post_params
    params.permit(:title, :text)
  end
end
