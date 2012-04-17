class UserMailer < ActionMailer::Base
  #default :from => "support@requirementbox.com"


  def password_reset(user)
    @reset_password_link = reset_password_url(user.perishable_token)
    mail(:from=>"password@requirementbox.com",:to => user.email,
       :subject => "Password Reset"
       ) 
  end

  def activation_instructions(user)
    @account_activation_url = activate_account_url(user.perishable_token)

    mail(:to => user.email,
         :subject => "Activation Instructions"

    ) 
  end

  def activation_instructions_for_paypal(user,url)
    @url = url

    mail(:to => user.email,
         :subject => "Activation Instructions for paypal"

    )
  end

  def activation_confirmation(user,user_plan,plan)
    @plan=plan
    @user_plan=user_plan
    @user_name=user.email
    mail(:to => user.email,
         :subject => "Activation Complete")
  end

  def member_activation(member)
    @member_activation_link = member_activation_url(member.perishable_token)
    mail(:to => member.email,
       :subject => "Member Activation",:from => "support@requirementbox.com"
       )
  end

  def member_activation_confirmation(member)
      @member_name=member.email
      mail(:to => member.email,
           :subject => "Activation Complete")
  end

  def member_password_reset(member)
      @reset_password_link = member_activation_url(member.perishable_token)
      mail(:to => member.email,
         :subject => "Password Reset"
         )
  end

  def member_notification(member,message,email)
    @message=message
    mail(:to => email,
         :subject => "Change Account Details"
         )
  end

  def email_change_activation(user,email)

      @update_email_link = update_email_url(:id=>user.id,:email=>email)
      mail(:to => email,
         :subject => "Email Validation"
         )
  end

  def email_change_activation_member(member,email)

      @update_email_member_link = update_email_member_url(:id=>member.id,:email=>email)
      mail(:to => email,
         :subject => "Email Validation"
         )
    end

  def send_help_request(help)
    @message=help.email_content
    mail(:to => "webmaster@requirementbox.com",
       :subject => "Support request",
       :from => help.sender_email
       )
  end

  def notification_email_create_use(user,first_name,usecase)
     @message="To view this use case,please follow this link :" + "#{REQBEnv::DEFAULT_HOST}"+use_case_path(usecase.id)
     subject="UC#{usecase.id}: #{usecase.name} has been created by #{first_name}"
     user.notification_message.create(:subject => subject,:message=>@message,:project_id=>usecase.project_id)
      mail(:to => user.email,
         :subject => subject
         )

  end

  def notification_email_create_file(user,first_name,file1)
       @message="To view this file,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+project_file_path(file1.id)
       subject="#{file1.file_file_name} has been uploaded to the system"
       user.notification_message.create(:subject => subject,:message=>@message,:project_id=>file1.project_id)
        mail(:to => user.email,
           :subject => subject
           )

    end

  def notification_email_create_def(user,first_name,def1)
         @message="To view this term,please follow this link :" + "#{REQBEnv::DEFAULT_HOST}"+definition_path(def1.id)
         subject="A new term,#{def1.term} has been added to the Definitions list by #{first_name}"
         user.notification_message.create(:subject => subject,:message=>@message,:project_id=>def1.project_id)
          mail(:to => user.email,
             :subject => subject
             )

      end

  def notification_email_create_req(user,first_name,req)
       @message="To view this requirement,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+requirement_path(req.id)
       subject="REQ#{req.id}: #{req.name} has been created by #{first_name}"
       user.notification_message.create(:subject => subject,:message=>@message,:project_id=>req.project_id)
       mail(:to => user.email,
           :subject => subject
           )

    end

  def notification_email_approve_use(user,first_name,usecase)
      @message="USE CASE#{usecase.id}: #{usecase.name} has been approved and cannot now be modified.Please contact #{first_name} if you think that this use case was approved in error.To view this use case,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+use_case_path(usecase.id)
      subject = "USE CASE#{usecase.id}: #{usecase.name} has been approved by #{first_name}"
      user.notification_message.create(:subject => subject,:message=>@message,:project_id=>usecase.project_id)
      mail(:to => user.email,
         :subject => subject
         )

  end

  def notification_email_approve_req(user,first_name,req)
        @message="REQ#{req.id}: #{req.name} has been approved and cannot now be modified.Please contact #{first_name} if you think that this requirement was approved in error.To view this requirement,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+requirement_path(req.id)
        subject="REQ#{req.id}: #{req.name} has been approved by #{first_name}"
        user.notification_message.create(:subject => subject,:message=>@message,:project_id=>req.project_id)
        mail(:to => user.email,
           :subject => subject
           )

    end

  def notification_email_no_approve_req(user,first_name,req)
          @message="The requirement's status was modified by #{first_name}.To view this requirement,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+requirement_path(req.id)
          subject = "REQ#{req.id}: #{req.name} was approved but now has the status #{req.status}"
          user.notification_message.create(:subject => subject,:message=>@message,:project_id=>req.project_id)
          mail(:to => user.email,
             :subject => subject
             )

      end

  def notification_email_no_approve_use(user,first_name,usecase)
            @message="The use case's status was modified by #{first_name}.To view this use case,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+use_case_path(usecase.id)
            subject = "UC#{usecase.id}: #{usecase.name} was approved but now has the status #{usecase.status}"
            user.notification_message.create(:subject => subject,:message=>@message,:project_id=>usecase.project_id)
            mail(:to => user.email,
               :subject => subject
               )

        end

  def notification_email_review_use(user,first_name,usecase)
    @message="UC#{usecase.id}: #{usecase.name} has been flagged for review and is now ready for approval. To view this use case,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+use_case_path(usecase.id)
    subject="UC#{usecase.id}: #{usecase.name} has been flagged for review by #{first_name}"
    user.notification_message.create(:subject => subject,:message=>@message,:project_id=>usecase.project_id)
    mail(:to => user.email,
         :subject => subject
         )

  end

  def notification_email_review_req(user,first_name,req)
       @message="REQ#{req.id}: #{req.name} has been flagged for review and is now ready for approval. To view this requirement,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+requirement_path(req.id)
       subject = "REQ#{req.id}: #{req.name} has been flagged for review by #{first_name}"
       user.notification_message.create(:subject => subject,:message=>@message,:project_id=>req.project_id)
        mail(:to => user.email,
           :subject => subject
           )

    end

  def notification_task_assigned(user,tracker,first_name)
     @message="To view this tracker,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+tracker_path(tracker.id)
     subject="Tracker#{tracker.id}: #{tracker.title} is assigned to you by #{first_name}"
     user.notification_message.create(:subject => subject,:message=>@message,:project_id=>tracker.project_id)
      mail(:to => user.email,
         :subject => subject 
         )

  end

  def notification_task_modified(user,tracker,first_name)
     @message="To view this tracker,please follow this link: " + "#{REQBEnv::DEFAULT_HOST}"+tracker_path(tracker.id)
     subject="Tracker#{tracker.id}: #{tracker.title} has been modified by #{first_name}"
     user.notification_message.create(:subject => subject,:message=>@message,:project_id=>tracker.project_id)
      mail(:to => user.email,
         :subject => subject
         )

  end

end
