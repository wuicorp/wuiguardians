class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.integer :user_id
      t.string :identifier
      t.timestamps
    end
  end
end
