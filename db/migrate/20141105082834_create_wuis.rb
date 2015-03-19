class CreateWuis < ActiveRecord::Migration
  def change
    create_table :wuis do |t|
      t.integer :user_id
      t.integer :vehicle_id
      t.string :wui_type
      t.string :status
      t.timestamps
    end
  end
end
