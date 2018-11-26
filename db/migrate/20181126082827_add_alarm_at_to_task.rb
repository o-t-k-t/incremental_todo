class AddAlarmAtToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :alarm, :boolean, null: false, default: false
  end
end
