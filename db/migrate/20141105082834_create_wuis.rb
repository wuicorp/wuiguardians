class CreateWuis < ActiveRecord::Migration
  def change
    create_table :wuis do |t|
      t.string :identifier
      t.integer :user_id
      t.integer :vehicle_id
      t.string :utility
      t.timestamps
    end
  end
end
