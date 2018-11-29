class TasksLoyalty < ApplicationLoyalty
  def initialize(user, task)
    @user = user
    @task = task
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
    true
  end

  def create?
    @user.id == @task.user_id
  end

  def update?
    @user.id == @task.user_id
  end

  def destroy?
    @user.id == @task.user_id
  end
end
