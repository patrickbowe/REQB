class Tracker < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :member
  has_and_belongs_to_many :requirements
  has_and_belongs_to_many :use_cases
  has_and_belongs_to_many :project_files
  has_many :comments
  def find_user_name
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address[0].nil?
     first_name=address[0].first_name.capitalize
    else
     address=Member.find(:all,:conditions=>["id=?",self.user_id])
     first_name=address[0].first_name.capitalize

    end

  end

  def self.find_all_user
    user=User.find(:all,:select=>"addresses.first_name",:joins=>"JOIN addresses on users.id=addresses.user_id")
    member=Member.find(:all,:select=>"first_name")
    return user.concat(member)
  end

  def self.find_tracker(project_id)
    tracker1=Tracker.find(:all,:conditions=>["project_id=? and flag_tracker=?",project_id,true],:order => "due")
    tracker2=Tracker.find(:all,:conditions=>["project_id=? and flag_tracker!=?",project_id,true],:order => "due")

    return tracker2.concat(tracker1)
  end

    def self.find_tracker_by_req(req)
    tracker1=req.trackers.find(:all,:conditions=>["flag_tracker=?",true])
    tracker2=req.trackers.find(:all,:conditions=>["flag_tracker!=?",true],:order => "created_at desc")

    return tracker2.concat(tracker1)
    end

  def self.check_attached_tracker_items(id)
     tracker=Tracker.find(id)
     comments=tracker.comments.find :all
     req=tracker.requirements.find :all
     use=tracker.use_cases.find :all
     flag="false"
     if comments.empty? and req.empty? and use.empty?
       flag="true"
     end
     return flag

  end

  def self.find_link_req_tracker(req,tracker)
    req_tracker=tracker.requirements.include?(req)

  end

  def self.insert_req_tracker(req,tracker)
     tracker.requirements << req
  end

  def self.find_link_use_tracker(use,tracker)
    use_tracker=tracker.use_cases.include?(use)

  end

  def self.insert_use_tracker(use,tracker)
     tracker.use_cases << use
  end

end
