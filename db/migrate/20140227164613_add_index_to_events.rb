class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :sk_event_id
  end
end
