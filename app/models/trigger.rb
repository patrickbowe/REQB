class Trigger < ActiveRecord::Base
  belongs_to :use_case
  validates_uniqueness_of  :title,:scope => [:use_case_id]
end
