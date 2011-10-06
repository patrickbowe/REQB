class CreateUserPlans < ActiveRecord::Migration
  def self.up
    create_table :user_plans do |t|
      t.references :plan
      t.references :user
      t.integer :project_count,:default => 0
      t.integer :storage,:default => 0
      t.integer :member_count,:default => 0
      t.text :path
      t.timestamps
    end
  end

  def self.down
    drop_table :user_plans
  end
end
