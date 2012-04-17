class AddDismissDashboardToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :dismiss_dashboard, :boolean,:default => false
  end

  def self.down
    remove_column :members, :dismiss_dashboard
  end
end
