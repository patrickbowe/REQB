class ProjectFilesTrackers < ActiveRecord::Migration
  def self.up
    create_table :project_files_trackers, :id => false do |t|
                       t.column :project_file_id, :integer
                       t.column :tracker_id, :integer
                     end

  end

  def self.down
    drop_table :project_files_trackers
  end

end
