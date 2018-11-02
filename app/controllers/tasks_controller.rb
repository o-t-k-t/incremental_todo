class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(:created_at)
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
      flash[:notice] = 'A task successfully created🎉'
      redirect_to tasks_path
    else
      flash.now[:notice] = 'A task rejected🤔'
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:notice] = 'A task successfully updated👍'
      redirect_to tasks_path
    else
      flash.now[:notice] = 'A task editing rejected😫'
      render :edit
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:notice] = 'A task deleted🚀'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
