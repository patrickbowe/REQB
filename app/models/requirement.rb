class Requirement < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :use_cases
  has_and_belongs_to_many :trackers
  has_many :project_files
  has_many :comments,:dependent => :destroy
  has_and_belongs_to_many :project_files
  #validates_uniqueness_of  :name
  def find_user_name_req
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address.empty?
     first_name=address[0].first_name.capitalize
    else
      address=Member.find(:all,:conditions=>["id=?",self.user_id])
      first_name=address[0].first_name.capitalize
    end
  end

  def self.check_attached_req_items(id)
        req=Requirement.find(id)
        use_case_req=req.use_cases.find :all
        tracker_req=req.trackers.find :all
        comments=req.comments.find :all
        file_req=req.project_files.find :all
        flag="false"
        if use_case_req.empty? and tracker_req.empty? and comments.empty? and file_req.empty?
          flag="true"
        end
        return flag

  end

  def self.find_link_req_use(use,req)
    req_use=req.use_cases.include?(use)

  end

  def self.insert_req_use(use,req)
     req.use_cases << use
  end

end
