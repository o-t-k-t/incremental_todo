class Admin::UsersController < ApplicationController
  include SessionControl
  include RoleRights

  before_action :require_logged_in
  before_action :require_admin_authority

  def index
    @users = User.id_order.page(params[:page]).per(20)
    @usernames_and_task_counts = @users.with_task.count_by_id_and_name
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
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報を更新しました'
      redirect_to admin_users_path
    else
      flash.now[:notice] = 'ユーザ情報を更新できませんでした'
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])

    flash[:notice] =
      if user.destroy
        "ユーザーID: #{user.id}を削除しました。"
      else
        "ユーザーID: #{user.id}は削除できませんでした。"
      end

    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
