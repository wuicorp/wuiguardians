class CreateUsersWuis < ActiveRecord::Migration
  def change
    create_table :users_wuis do |t|
      t.integer :user_id
      t.integer :wui_id
    end

    add_index :users_wuis, :wui_id
    add_index :users_wuis, :user_id
  end
end
