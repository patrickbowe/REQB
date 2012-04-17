class CreateUseCases < ActiveRecord::Migration
  def self.up
    create_table :use_cases do |t|
      t.references :project
      t.string :name
      t.string :status
      t.string :category
      t.text :goal
      t.string :delivered
      t.string :priority
      t.string :importance
      t.references :user
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :use_cases
  end
end
