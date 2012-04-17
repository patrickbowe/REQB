class AddKeybordToHelps < ActiveRecord::Migration
  def self.up
    add_column :helps, :tag, :text
    add_column :helps, :keywords, :text
  end

  def self.down
    remove_column :helps, :tag
    remove_column :helps, :keywords
  end
end
