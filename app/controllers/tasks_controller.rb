class TasksController < ApplicationController
  include SessionControl

  before_action :require_logged_in

  def index
    @q = current_user.tasks.ransack(search_params)

    @tasks =
      case params[:order_by]
      when 'create_at'
        @q.result.recent_page(params)
      when 'deadline'
        @tasks = @q.result.deadline_asc_page(params)
      when 'priority'
        @tasks = @q.result.priority_height_page(params)
      when nil
        @q.result.recent_page(params)
      else
        raise 'Illegal task order requeseted'
      end
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
    fire_task_event

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
    fire_task_event

    if @task.update(task_params)
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
    params.require(:task).permit(:name, :description, :deadline, :priority, :user_id)
  end

  def search_params
    return nil if params[:q].blank?

    params.require(:q).permit(:name_cont, status_eq_any: [])
  end

  def fire_task_event
    # ホワイトリストイベント処理
    case params[:status_event]
    when 'start'
      @task.start
    when 'complete'
      @task.complete
    when 'pend'
      @task.pend
    when nil
      nil
    else
      raise 'Illegal event received'
    end
  end
end
