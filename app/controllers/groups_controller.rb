class GroupsController < ApplicationController
  def index
    authorize!
    @groups = Group.all.page(params[:page])
  end

  def show
    @group = Group.find(params[:id])
    @owner = @group.owner
    @member_count = @group.users.count
    @membership = @group.memberships.find_by(user_id: current_user.id) || @group.memberships.build
    authorize! @group
  end

  def new
    authorize!
    @group = Group.new
  end

  def create
    authorize!
    @group = Group.new(group_params)
    render :new and return if @group.invalid?

    ms = Membership.create_with_group!(current_user, @group)
    redirect_to membership_path(ms)
  end

  def update
    @group = Group.find(params[:id])
    authorize! @group

    if @group.save
      flash[:notice] = I18n.t('グループを更新しました')
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    authorize! @group

    flash[:notice] = I18n.t('グループを削除しました')
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
