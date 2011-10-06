class AddPriviligeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :privilige, :string,:default => "Admin"
  end

  def self.down
  end
end
