class ProjectFile < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :member
  has_many :comments
  has_and_belongs_to_many :requirements
  has_and_belongs_to_many :use_cases
  has_and_belongs_to_many :trackers

  has_attached_file :file,
     :storage => :s3,
     :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
     :path => "/:style/:id/:filename"

 def find_user_name_file
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address.empty?
     first_name=address[0].first_name.capitalize
    else
      address=Member.find(:all,:conditions=>["id=?",self.user_id])
      first_name=address[0].first_name.capitalize
    end
 end

  def self.find_link_req(req,file)
    req_file=file.requirements.include?(req)
    
  end

  def self.insert_req_file(req,file)
     file.requirements << req
  end

  def self.find_link_use(use,file)
    use_file=file.use_cases.include?(use)
  end

    def self.insert_use_file(use,file)
       file.use_cases << use
    end

  def self.check_attached_file_items(id)
       file=ProjectFile.find(id)
       comments=file.comments.find :all
       req=file.requirements.find :all
       use=file.use_cases.find :all
       flag="false"
       if comments.empty? and req.empty? and use.empty?
         flag="true"
       end
       return flag

    end

end
