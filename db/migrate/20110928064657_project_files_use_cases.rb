class ProjectFilesUseCases < ActiveRecord::Migration
  def self.up
    create_table :project_files_use_cases, :id => false do |t|
                       t.column :project_file_id, :integer
                       t.column :use_case_id, :integer
                     end

  end

  def self.down
    drop_table :project_files_use_cases
  end
end
