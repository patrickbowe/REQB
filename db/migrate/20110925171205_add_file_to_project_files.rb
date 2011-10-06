class AddFileToProjectFiles < ActiveRecord::Migration
  def self.up
    add_column :project_files, :file_file_name, :string
    add_column :project_files, :file_content_type, :string
    add_column :project_files, :file_file_size, :integer
  end

  def self.down
    remove_column :project_files, :file_file_size
    remove_column :project_files, :file_content_type
    remove_column :project_files, :file_file_name
  end
end
