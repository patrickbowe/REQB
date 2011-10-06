class UseCase < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :requirements
  has_and_belongs_to_many :trackers
  has_one :use_case_detail,:dependent=>:destroy
  has_many :pre_conditions,:dependent=>:destroy
  has_many :post_conditions,:dependent=>:destroy
  has_many :success_conditions,:dependent=>:destroy
  has_many :triggers,:dependent=>:destroy
  has_many :business_rules,:dependent=>:destroy
  has_many :messages,:dependent=>:destroy
  has_many :actors,:dependent=>:destroy
  has_many :basic_flows,:dependent=>:destroy
  has_many :comments,:dependent=>:destroy
  has_and_belongs_to_many :project_files
  #validates_uniqueness_of  :name
  def find_user_name_use
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address[0].nil?
     first_name=address[0].first_name.capitalize
    else
     address=Member.find(:all,:conditions=>["id=?",self.user_id])
     first_name=address[0].first_name.capitalize
      
    end  

  end

  def self.check_attached_items(id)
    use_case=UseCase.find(id)
    pre=use_case.pre_conditions.find :all
    post=use_case.post_conditions.find :all
    succ=use_case.success_conditions.find :all
    actor=use_case.actors.find :all
    trigger=use_case.triggers.find :all
    rule=use_case.business_rules.find :all
    msg=use_case.messages.find :all
    use_case_req=use_case.requirements.find :all
    use_case_tracker=use_case.trackers.find :all
    comments=use_case.comments.find :all
    files=use_case.project_files.find :all
    flag="false"
    if use_case_req.empty? and pre.empty? and post.empty? and succ.empty? and rule.empty? and actor.empty? and msg.empty? and trigger.empty? and use_case_tracker.empty? and comments.empty? and files.empty?
      flag="true"
    end
    return flag
  end

  def self.find_link_req_use(req,use)
    req_use=use.requirements.include?(req)

  end

  def self.insert_req_use(req,use)
     use.requirements << req
  end

  
end
