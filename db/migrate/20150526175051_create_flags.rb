class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :user_id
      t.float :latitude
      t.float :longitude
      t.integer :radius
      t.timestamps
    end
  end
end
