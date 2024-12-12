class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :index, :show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Ao criar um usuário, já podemos retornar um token opcionalmente
      token = JsonWebToken.encode({ user_id: @user.id })
      render 'users/show', status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user && @user.update(user_params)
      render 'users/show', status: :ok
    else
      render json: { errors: "Não autorizado ou dados inválidos" }, status: :forbidden
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy
      head :no_content
    else
      render json: { error: "Não autorizado" }, status: :forbidden
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
