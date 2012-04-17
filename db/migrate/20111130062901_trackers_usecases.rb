class TrackersUsecases < ActiveRecord::Migration
  def self.up
    create_table :trackers_use_cases, :id => false do |t|
          t.integer :use_case_id
          t.integer :tracker_id
    end
  end

  def self.down
    drop_table :trackers_use_cases
  end
end
