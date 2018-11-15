class Admin::UsersController < ApplicationController
  include SessionControl

  def index
    @users = User.with_task.page(params[:page]).per(50)
    @usernames_and_task_counts = @users.count_by_id_and_name
  end

  def show
    @user = User.find(params[:id])
    @tasks = TaskDecorator.decorate_collection(@user.tasks.page(params[:page]).per(10))
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user.id)
    else
      render :new
    end
  end

  def destroy
    user = User.find(params[:id])
    flash[:notice] = "ユーザーID: #{user.id}を削除しました。"
    user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
