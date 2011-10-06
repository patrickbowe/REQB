class TrackersUseCases < ActiveRecord::Migration
  def self.up
    create_table :trackers_use_cases, :id => false do |t|
                   t.column :tracker_id, :integer
                   t.column :use_case_id, :integer
                 end

  end

  def self.down
    drop_table :trackers_use_cases
  end
end
