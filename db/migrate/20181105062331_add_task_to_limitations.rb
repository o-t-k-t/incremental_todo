class AddTaskToLimitations < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :name, :string, limit: 255
    change_column :tasks, :description, :text, limit: 2000
  end
end
