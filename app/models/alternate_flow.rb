class AlternateFlow < ActiveRecord::Base
  belongs_to :basic_flow
  has_many :alternate_basic_flows, :dependent=>:destroy
  validates_uniqueness_of :title, :scope => [:basic_flow_id]
end
