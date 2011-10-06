class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :title
      t.references :user
      t.references :tracker
      t.references :requirement
      t.references :use_case
      t.references :member
      t.references :project_file
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
