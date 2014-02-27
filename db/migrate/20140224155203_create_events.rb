class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.DateTime :time
      t.string :distinct_id
      t.integer :wifi
      t.integer :user_id

      t.timestamps
    end
    add_index :events, [:user_id, :distinct_id, :time, :name]
  end
end
