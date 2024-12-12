class CommentsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show, :create]

  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def create
    # Cria um comentário sem autenticação
    @comment = Comment.new(comment_params)
    if @comment.save
      render 'comments/show', status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    # Aqui assumiremos que apenas o usuário logado pode alterar comentários.
    # Mas não temos vínculo de usuário em comentários.
    # Podemos pular a checagem ou assumir que somente admins ou algo assim pode editar.
    # Vamos apenas exigir autenticação.
    if @comment.update(comment_params)
      render 'comments/show', status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.permit(:name, :comment, :post_id)
  end
end
