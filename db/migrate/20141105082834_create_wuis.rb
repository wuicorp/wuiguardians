class CreateWuis < ActiveRecord::Migration
  def change
    create_table :wuis do |t|
      t.string :identifier
      t.integer :owner_id
      t.integer :receiver_id
      t.string :utility
      t.timestamps
    end
  end
end
