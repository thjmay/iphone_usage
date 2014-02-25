class AddDetailsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :sk_event_id, :string
  end
end
