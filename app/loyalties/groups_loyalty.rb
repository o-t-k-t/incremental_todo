class GroupsLoyalty < ApplicationLoyalty
  def initialize(user, group)
    @user = user
    @group = group
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def edit?
    @user == @group.owner
  end

  def create?
    true
  end

  def update?
    @user == @group.owner
  end

  def destroy?
    @user == @group.owner
  end
end
