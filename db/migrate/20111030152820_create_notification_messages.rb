class CreateNotificationMessages < ActiveRecord::Migration
  def self.up
    create_table :notification_messages do |t|
      t.text :subject
      t.text :message
      t.references :user
      t.references :member
      t.references :project
      t.boolean :dismiss_flag,:default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :notification_messages
  end
end
