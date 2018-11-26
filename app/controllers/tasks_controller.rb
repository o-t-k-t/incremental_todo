class TasksController < ApplicationController
  include SessionControl

  before_action :validate_status_event

  def index
    # タスク検索パラメタ処理
    @q = current_user.tasks.ransack(search_params)
    @tasks = @q.result

    @tasks = @tasks.labeled(params[:label_id]) if params[:label_id]

    @tasks =
      case params[:order_by]
      when 'create_at' then @tasks.newness_order
      when 'deadline' then @tasks.urgency_order
      when 'priority' then @tasks.priority_order
      when nil then @tasks.newness_order
      else
        raise 'Illegal task order requeseted'
      end.page(params[:page])

    # View系前処理
    @states = @tasks.aasm.states
    @tasks = TaskDecorator.decorate_collection(@tasks)

    @labels = Label.all
    @labels = LabelDecorator.decorate_collection(@labels)
  end

  def show
    @task = current_user.read_task(params[:id])
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
    @labels = LabelDecorator.decorate_collection(Label.all)
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:notice] = I18n.t('tasks.create_success')
      redirect_to tasks_path
    else
      @task = @task.decorate
      @labels = LabelDecorator.decorate_collection(Label.all)

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
      @labels = LabelDecorator.decorate_collection(Label.all)

      flash.now[:notice] = I18n.t('tasks.update_fail')
      render :edit
    end
  end

  def destroy
    current_user.remove_task(params[:id])
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
      label_ids: [],
      labels_attributes: %i[id name descriptione color]
    )
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
