class UsersLoyalty < ApplicationLoyalty
  def show?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end
end
