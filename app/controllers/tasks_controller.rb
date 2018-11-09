class TasksController < ApplicationController
  def index
    @q = Task.ransack(search_params)

    @tasks =
      case params[:order_by]
      when 'create_at'
        @tasks = @q.result.recent
      when 'deadline'
        @tasks = @q.result.deadline_asc
      when nil
        @tasks = @q.result.recent
      else
        raise 'Illegal task order requeseted'
      end

    @states = @tasks.aasm.states
    @tasks = @tasks.map(&:decorate)
  end

  def show
    @task = Task.find(params[:id]).decorate
  end

  def new
    @task = Task.new.decorate
  end

  def edit
    @task = Task.find(params[:id]).decorate
  end

  def create
    @task = Task.new(task_params)
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
    @task = Task.find(params[:id])
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
    Task.find(params[:id]).destroy
    flash[:notice] = I18n.t('tasks.delete_complete')
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :deadline)
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
