class AddInstallTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :install_time, :integer
  end
end
