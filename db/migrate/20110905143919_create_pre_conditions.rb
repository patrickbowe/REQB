class CreatePreConditions < ActiveRecord::Migration
  def self.up
    create_table :pre_conditions do |t|
      t.text :title
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :pre_conditions
  end
end
