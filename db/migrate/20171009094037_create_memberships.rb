class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end
    add_index :memberships, :group_id
    add_index :memberships, :user_id
    add_index :memberships, :role_id
  end
end
