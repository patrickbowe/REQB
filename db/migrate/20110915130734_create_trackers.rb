class CreateTrackers < ActiveRecord::Migration
  def self.up
    create_table :trackers do |t|
      t.text :title
      t.string :category
      t.string :assigned
      t.string :due
      t.boolean :flag_tracker
      t.references :member
      t.references :user
      t.references :project
      t.timestamps
    end
  end

  def self.down
    drop_table :trackers
  end
end
