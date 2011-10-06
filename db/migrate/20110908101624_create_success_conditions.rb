class CreateSuccessConditions < ActiveRecord::Migration
  def self.up
    create_table :success_conditions do |t|
      t.text :title
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :success_conditions
  end
end
