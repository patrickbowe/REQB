class RequirementsTrackers < ActiveRecord::Migration
  def self.up
    create_table :requirements_trackers, :id => false do |t|
           t.column :requirement_id, :integer
           t.column :tracker_id, :integer
         end

  end

  def self.down
    drop_table :requirements_trackers
  end
end
