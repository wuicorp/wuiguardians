class CreateWuis < ActiveRecord::Migration
  def change
    create_table :wuis do |t|
      t.integer :user_id
      t.string :vehicle_identifier
      t.float :latitude
      t.float :longitude
      t.string :wui_type
      t.string :status
      t.timestamps
    end
  end
end
