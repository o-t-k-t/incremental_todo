class TasksController < ApplicationController
  include SessionControl

  before_action :validate_status_event

  def index
    @q = current_user.tasks.ransack(search_params)

    @tasks =
      case params[:order_by]
      when 'create_at' then @q.result.newness_order
      when 'deadline' then @q.result.urgency_order
      when 'priority' then @q.result.priority_order
      when nil then @q.result.newness_order
      else
        raise 'Illegal task order requeseted'
      end

    @tasks = @tasks.page(params[:page])

    @states = @tasks.aasm.states
    @tasks = TaskDecorator.decorate_collection(@tasks)

    @labels = Label.all
    @labels = LabelDecorator.decorate_collection(@labels)
  end

  def show
    @task = current_user.tasks.find(params[:id]).decorate
    @labels = LabelDecorator.decorate_collection(@task.labels)
  end

  def new
    @task = current_user.tasks.build.decorate
  end

  def edit
    @task = current_user.tasks.find(params[:id]).decorate
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:notice] = I18n.t('tasks.create_success')
      redirect_to tasks_path
    else
      @task = @task.decorate
      flash.now[:notice] = I18n.t('tasks.create_fail')
      render :new
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update_and_fire_event(task_params, params[:status_event])
      flash[:notice] = I18n.t('tasks.update_success')
      redirect_to tasks_path
    else
      @task = @task.decorate
      flash.now[:notice] = I18n.t('tasks.update_fail')
      render :edit
    end
  end

  def destroy
    current_user.tasks.find(params[:id]).destroy
    flash[:notice] = I18n.t('tasks.delete_complete')
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :deadline, :priority, :user_id, :status_event)
  end

  def search_params
    return nil if params[:q].blank?

    params.require(:q).permit(:name_cont, status_eq_any: [])
  end

  def validate_status_event
    return if params[:status_event].nil?
    return if %w[start complete pend].include?(params[:status_event])

    raise 'Illegal event received'
  end
end
