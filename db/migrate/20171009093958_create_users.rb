class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.timestamps
    end
    add_index :users, :first_name
    add_index :users, :last_name
  end
end
