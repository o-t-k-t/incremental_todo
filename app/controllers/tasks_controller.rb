class TasksController < ApplicationController
  include SessionControl

  before_action :require_logged_in

  def index
    # タスク検索パラメタ処理
    @q = current_user.tasks.ransack(search_params)

    @tasks = @q.result

    @tasks = @tasks.labeled(params[:label_id]) if params[:label_id]

    @tasks =
      case params[:order_by]
      when 'create_at'
        @tasks.recent_page(params)
      when 'deadline'
        @tasks.deadline_asc_page(params)
      when 'priority'
        @tasks.priority_height_page(params)
      when nil
        @tasks.recent_page(params)
      else
        raise 'Illegal task order requeseted'
      end

    # View系前処理
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

    @task.labels.build
    LabelDecorator.decorate_collection(@task.labels)

    @labels = LabelDecorator.decorate_collection(Label.all)
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
    params.require(:task).permit(
      :name,
      :description,
      :deadline,
      :priority,
      :user_id,
      labels_attributes: %i[id name descriptione color]
    )
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
