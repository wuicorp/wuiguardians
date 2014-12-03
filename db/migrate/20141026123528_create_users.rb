class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :phone_prefix, null: false
      t.string :phone_number, null: false
      t.string :confirmation_code
      t.timestamps
    end

    add_index :users, [:phone_prefix, :phone_number]
  end
end
