class CreateTriggers < ActiveRecord::Migration
  def self.up
    create_table :triggers do |t|
      t.text :title
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :triggers
  end
end
