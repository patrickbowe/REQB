class ProjectFilesRequirements < ActiveRecord::Migration
  def self.up
    create_table :project_files_requirements, :id => false do |t|
                       t.column :project_file_id, :integer
                       t.column :requirement_id, :integer
                     end

  end

  def self.down
    drop_table :project_files_requirements
  end
end
