module UseCaseDetailsHelper
  def alter_count(basic)
    count1=basic.alternate_flows.count
  end

  def find_alternate_basic_flow(alternate_flow)
    alter_basic_flows=alternate_flow.alternate_basic_flows.order("seq_number ASC")
  end
end
