class Comment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :use_case
  belongs_to :tracker
  belongs_to :project_file
end
