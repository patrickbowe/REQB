class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.boolean :task_assigned,:default=> true
      t.boolean :task_modified,:default=> true
      t.boolean :req_approved,:default=> true
      t.boolean :use_approved,:default=> false
      t.boolean :req_review,:default=> false
      t.boolean :use_review,:default=> false
      t.boolean :use_created,:default=> false
      t.boolean :req_created,:default=> false
      t.boolean :def_created,:default=> false
      t.boolean :file_uploaded,:default=> false
      t.boolean :req_longer_approved,:default=> true
      t.boolean :use_longer_approved,:default=> true
      t.references :user
      t.references :member
      t.references :project
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
