class AddTaskToPriority < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :integer, index: true, null: false, default: 2
  end
end
