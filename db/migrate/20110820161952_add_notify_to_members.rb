class AddNotifyToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :notify, :boolean,:default => false
  end

  def self.down
    remove_column :members, :notify 
  end
end
