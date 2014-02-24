class AddIndexToUsersDistinctId < ActiveRecord::Migration
  def change
    add_index :users, :distinct_id, unique: true
  end
end
