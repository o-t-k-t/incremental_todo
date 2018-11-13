class TaskDecorator < ApplicationDecorator
  delegate_all

  def deadline
    if object.deadline
      "〜#{I18n.l(object.deadline, format: :long)}"
    else
      I18n.t('tasks.no_deadline')
    end
  end

  def priority
    I18n.t("activerecord.attributes.task.#{object.priority}")
  end

  def priority_options_for_select
    priorities =
      Task.priorities.keys.map do |p|
        [I18n.t("activerecord.attributes.task.#{p}"), p]
      end

    h.options_for_select(priorities, selected: task.priority)
  end

  # 状態に応じた遷移イベント選択フォームの生成
  def event_select
    h.render '/tasks/event_select', task: self
  end

  def status_options_for_select
    h.options_for_select(events_and_names)
  end

  private

  def events_and_names
    object.aasm.events(permitted: true).map do |e|
      [I18n.t("activerecord.events.task/#{e.name}"), e.name]
    end
  end
end
