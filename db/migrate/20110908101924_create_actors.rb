class CreateActors < ActiveRecord::Migration
  def self.up
    create_table :actors do |t|
      t.text :title
      t.references :use_case
      t.references :project
      t.boolean :flag,:default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :actors
  end
end
