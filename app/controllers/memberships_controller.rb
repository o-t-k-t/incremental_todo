class MembershipsController < ApplicationController
  def index
    authorize!
    @memberships = current_user.memberships.includes(:group).page(params[:page])
  end

  def show
    @membership = current_user.memberships.find(params[:id])
    @group = @membership.group
    @owner = @group.owner
    @members = @group.users.includes(:tasks).page(params[:page])

    authorize! @membership
  end

  def create
    membership = current_user.memberships.build(group_id: params[:membership][:group_id], role: :general)
    authorize! membership

    membership.save!
    flash[:notice] = t('memberships.create_success')
    redirect_to membership_path(membership.id)
  end

  def destroy
    membership = current_user.memberships.find(params[:id])
    authorize! membership

    membership.destroy!

    flash[:notice] = t('memberships.delete_success')
    redirect_to root_path
  end
end
