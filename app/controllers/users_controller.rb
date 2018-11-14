class UsersController < ApplicationController
  include SessionControl

  before_action :require_logged_in, except: %i[new create]

  def show
    unless current_user?(params[:id])
      raise 'Another user information requested'
    end

    @user = User.find(params[:id])
  end

  def new
    redirect_to root_path and return if logged_in?

    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def destroy
    @user = User.find_by(params[:id]).destroy
    redirect_to user_new_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
