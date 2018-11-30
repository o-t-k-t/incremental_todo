class RemoveAlarmToTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :alarm, :boolean
  end
end
