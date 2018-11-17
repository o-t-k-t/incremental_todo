class Admin::UsersController < ApplicationController
  include SessionControl

  def index
    @users = User.with_task.id_order.page(params[:page]).per(20)
    @usernames_and_task_counts = @users.count_by_id_and_name
    # @usernames_and_task_counts = User.with_task.id_order.count_by_id_and_name
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

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報を更新しました'
      redirect_to admin_user_path
    else
      flash.now[:notice] = 'ユーザ情報を更新できませんでした'
      render :edit
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
