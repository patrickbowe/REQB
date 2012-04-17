class AddStatusToUserPlans < ActiveRecord::Migration
  def self.up
    add_column :user_plans, :status, :text
  end

  def self.down
  end
end
