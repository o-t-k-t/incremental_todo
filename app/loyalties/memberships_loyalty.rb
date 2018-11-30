class MembershipsLoyalty < ApplicationLoyalty
  def initialize(user, membership)
    @user = user
    @membership = membership
  end

  def index?
    true
  end

  def show?
    @user == @membership.user
  end

  def create?
    true
  end

  def destroy?
    @user == @membership.user && @membership.role != 'owner'
  end
end
