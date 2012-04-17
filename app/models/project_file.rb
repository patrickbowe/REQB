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

  def self.notification_create(user_id,project_id,file1)
      users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
      if !users.empty?
        users.each do |u|
          if u.member_id.nil? and u.file_uploaded==true and !u.user_id.nil?
            user=User.find(u.user_id)
            first_name=file1.find_user_first_name(user.id)
            UserMailer.notification_email_create_file(user,first_name,file1).deliver
          else if !u.member_id.nil? and u.file_uploaded==true and !u.user_id.nil?
            user=Member.find(u.member_id)
            first_name=file1.find_member_first_name(user.id)
            UserMailer.notification_email_create_file(user,first_name,file1).deliver
          end
          end
        end
      end

    end

  def find_member_first_name(id)
             user=Member.find(id)
             if !user.first_name.nil?
               if !user.first_name.empty?
                 return first_name=user.first_name
               else
                 return first_name=user.email
               end
             else
               return first_name=user.email
             end
     end

     def find_user_first_name(id)

             user=User.find(id)
             address=user.address
             if !address.first_name.nil?
                if !address.first_name.empty?
                   return first_name=address.first_name
                else
                   return first_name=user.email
                end
             else
               return first_name=user.email
             end

     end

   def find_first_name_email(u)
        if !u.user_id.nil? and !u.member_id.nil?
           user=Member.find(u.member_id)
           if !user.first_name.nil?
             if !user.first_name.empty?
               return first_name=user.first_name
             else
               return first_name=user.email
             end
           else
             return first_name=user.email
           end
        else !u.user_id.nil? and u.member_id.nil?
           user=User.find(u.user_id)
           address=user.address
           if !address.first_name.nil?
              if !address.first_name.empty?
                 return first_name=address.first_name
              else
                 return first_name=user.email
              end
           else
             return first_name=user.email
           end
        end
      end

  
  def find_first_name(u)
       if !u.user_id.nil? and !u.member_id.nil?
          user=Member.find(u.member_id)
          return first_name=user.first_name
       else !u.user_id.nil? and u.member_id.nil?
          user=User.find(u.user_id)
          address=user.address
          return first_name=address.first_name
       end
     end
  
end
