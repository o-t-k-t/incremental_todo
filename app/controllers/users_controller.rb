class UsersController < ApplicationController
  include SessionControl

  skip_before_action :require_logged_in, only: %i[new create]

  def show
    @user = current_user
  end

  def new
    redirect_to root_path and return if logged_in?

    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to user_path
    else
      render :new
    end
  end

  def destroy
    current_user.destroy
    redirect_to user_new_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
