class AddTaskToDeadline < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime
  end
end
