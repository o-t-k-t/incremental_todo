class UsersController < ApplicationController
  skip_before_action :require_logged_in, only: %i[new create]

  def show
    authorize!
    @user = current_user.decorate
  end

  def new
    redirect_to root_path and return if logged_in?

    authorize!
    @user = User.new
  end

  def create
    authorize!

    @user = User.new(user_params)
    if @user.save
      @user.avatar.attach(params[:user][:avatar])

      log_in(@user)
      redirect_to user_path
    else
      render :new
    end
  end

  def destroy
    authorize!

    current_user.destroy
    redirect_to user_new_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :avetar, :password, :password_confirmation)
  end
end
