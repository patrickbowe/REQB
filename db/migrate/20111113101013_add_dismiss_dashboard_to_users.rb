class AddDismissDashboardToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :dismiss_dashboard, :boolean,:default => false
  end

  def self.down
    remove_column :users, :dismiss_dashboard 
  end
end
