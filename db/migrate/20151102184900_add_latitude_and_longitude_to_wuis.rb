class AddLatitudeAndLongitudeToWuis < ActiveRecord::Migration
  def change
    add_column :wuis, :latitude, :float
    add_column :wuis, :longitude, :float
  end
end
