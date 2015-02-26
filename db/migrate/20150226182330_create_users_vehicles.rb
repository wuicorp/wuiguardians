class CreateUsersVehicles < ActiveRecord::Migration
  def change
    create_table :users_vehicles do |t|
      t.integer :user_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
