class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.string :name
      t.string :status
      t.string :category
      t.string :type1
      t.references :project
      t.string :importance
      t.string :priority
      t.string :verification
      t.references :user
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
