class AlternateFlow < ActiveRecord::Base
  belongs_to :basic_flow
  has_many :alternate_basic_flows, :dependent=>:destroy
end
