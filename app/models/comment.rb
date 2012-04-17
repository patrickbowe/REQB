class Comment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :use_case
  belongs_to :tracker
  belongs_to :project_file
  #validates_uniqueness_of :title, :scope => [:requirement_id]
  #validates_uniqueness_of :title, :scope => [:use_case_id]
  #validates_uniqueness_of :title, :scope => [:tracker_id]
  #validates_uniqueness_of :title, :scope => [:project_file_id]
  validates :title, :uniqueness => {:scope => [:requirement_id, :use_case_id,:tracker_id,:project_file_id]}

end
