class PreCondition < ActiveRecord::Base
  belongs_to :use_case
  validates_uniqueness_of  :title
end
