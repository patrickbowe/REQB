class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :plan_type
      t.integer :project_count
      t.string :storage
      t.integer :member_count
      t.integer :price
      t.timestamps
      
    end
  end

  def self.down
    drop_table :plans
  end
end
