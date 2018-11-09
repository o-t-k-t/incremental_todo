class AddTaskToStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :string, null: false, default: 'not_started'
  end
end
