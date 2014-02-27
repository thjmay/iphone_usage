class AddSkTicketedEventToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sk_ticketed_event, :integer
  end
end
