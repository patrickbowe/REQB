class CreateTrackers < ActiveRecord::Migration
  def self.up
    create_table :trackers do |t|
      t.text :title
      t.string :category
      t.string :assigned
      t.integer :assigned_subscriber_id
      t.date :due
      t.boolean :flag_tracker
      t.references :member
      t.references :user
      t.references :project
      t.references :requirement
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :trackers
  end
end
