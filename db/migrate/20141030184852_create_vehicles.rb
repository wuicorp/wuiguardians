class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :identifier
      t.timestamps
    end
  end
end
