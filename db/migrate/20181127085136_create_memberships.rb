class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true, null: false
      t.references :group, foreign_key: true, null: false
      t.integer :role, null: false, index: true

      t.timestamps
    end
    add_index :memberships, [:user_id, :group_id], unique: true
  end
end
