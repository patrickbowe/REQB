class Category < ActiveRecord::Base
  belongs_to :projects
  validates_uniqueness_of :title, :scope => [:project_id]
end
