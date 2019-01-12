class TasksController < ApplicationController
  decorates_assigned :task
  before_action :validate_status_event

  def index
    authorize! nil

    # タスク検索パラメタ処理
    @q = current_user.tasks.ransack(search_params)
    @tasks = @q.result
    @tasks = @tasks.labeled(params[:label_id]) if params[:label_id]

    @states = @tasks.aasm.states

    @tasks = @tasks.page(params[:page]).decorate
    @labels = Label.decorate
  end

  def show
    @task = current_user.read_task(params[:id])

    authorize! @task
  end

  def new
    @task = current_user.tasks.build
    @task.labels.build
    @labels = Label.decorate
    authorize! @task
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    @labels = Label.decorate
    authorize! @task
  end

  def create
    @task = current_user.tasks.build(task_params)
    authorize! @task

    if @task.save
      flash[:notice] = I18n.t('tasks.create_success')
      redirect_to tasks_path
    else
      @labels = Label.decorate

      flash.now[:notice] = I18n.t('tasks.create_fail')
      render :new
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])
    authorize! @task

    if @task.update_and_fire_event(task_params, params[:status_event])
      flash[:notice] = I18n.t('tasks.update_success')
      redirect_to tasks_path
    else
      @labels = Label.decorate

      flash.now[:notice] = I18n.t('tasks.update_fail')
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    authorize! @task

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
      attachments: [],
      label_ids: [],
      labels_attributes: %i[id name descriptione color]
    )
  end

  def search_params
    return nil if params[:q].blank?

    params.require(:q).permit(:name_cont, :s, status_eq_any: [])
  end

  def validate_status_event
    return if params[:status_event].nil?
    return if %w[start complete pend].include?(params[:status_event])

    raise 'Illegal event received'
  end
end
