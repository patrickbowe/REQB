class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :project_name
      t.text :description
      t.text :path
      t.references :user
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
