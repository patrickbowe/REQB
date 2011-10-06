class RequirementsUseCases < ActiveRecord::Migration
  def self.up
    create_table :requirements_use_cases, :id => false do |t|
       t.column :requirement_id, :integer
       t.column :use_case_id, :integer
     end

  end

  def self.down
    drop_table :requirements_use_cases
  end
end
