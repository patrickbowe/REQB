class CreateDefinitions < ActiveRecord::Migration
  def self.up
    create_table :definitions do |t|
      t.text :term
      t.text :definition
      t.references :project
      t.references :user
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :definitions
  end
end
