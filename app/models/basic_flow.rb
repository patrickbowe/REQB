class BasicFlow < ActiveRecord::Base
  belongs_to :use_case
  has_many :alternate_flows, :dependent=>:destroy
  #validates_uniqueness_of :action,:scope => [:use_case_id]
  #validates_uniqueness_of :response,:scope => [:use_case_id],:if => Proc.new {|c| c.action.blank? or c.action.nil?}
  
end
