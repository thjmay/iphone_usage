class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :distinct_id
      t.string :sk_user_id
      t.integer :full_user
      t.integer :transactions
      t.string :app_version

      t.timestamps
    end
  end
end
