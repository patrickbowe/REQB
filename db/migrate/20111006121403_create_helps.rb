class CreateHelps < ActiveRecord::Migration
  def self.up
    create_table :helps do |t|
      t.text :faq
      t.text :result
      t.timestamps
    end
  end

  def self.down
    drop_table :helps
  end
end
