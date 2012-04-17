class AddSubscriptionUrlToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :subscription_url, :text
  end

  def self.down
  end
end
