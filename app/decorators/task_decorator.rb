class TaskDecorator < ApplicationDecorator
  delegate_all

  def deadline
    if object.deadline
      I18n.l(object.deadline, format: :long)
    else
      I18n.t('tasks.no_deadline')
    end
  end
end
