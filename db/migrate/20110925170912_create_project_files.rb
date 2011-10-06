class CreateProjectFiles < ActiveRecord::Migration
  def self.up
    create_table :project_files do |t|
      t.string :type1
      t.text :description
      t.references :user
      t.references :project
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :project_files
  end
end
