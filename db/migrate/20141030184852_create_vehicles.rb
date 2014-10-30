class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.references :user, index: true
      t.string :identifier
    end
  end
end
