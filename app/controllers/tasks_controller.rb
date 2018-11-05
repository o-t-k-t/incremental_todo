class TasksController < ApplicationController
  def index
    @tasks = Task.recent
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    if Task.create(task_params)
      flash[:notice] = I18n.t('tasks.create_success')
      redirect_to tasks_path
    else
      flash.now[:notice] = I18n.t('tasks.create_fail')
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:notice] = I18n.t('tasks.update_success')
      redirect_to tasks_path
    else
      flash.now[:notice] = I18n.t('tasks.update_fail')
      render :edit
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:notice] = I18n.t('tasks.delete_complete')
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
