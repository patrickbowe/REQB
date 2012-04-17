class RequirementsTrackers < ActiveRecord::Migration
  def self.up
    create_table :requirements_trackers, :id => false do |t|
          t.integer :requirement_id
          t.integer :tracker_id
    end

  end

  def self.down
    drop_table :requirements_trackers
  end
end
