class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  #default_url_options[:host] = "afternoon-sky-273.heroku.com"

  def password_reset(user)
    @reset_password_link = reset_password_url(user.perishable_token)
    mail(:to => user.email,
       :subject => "Password Reset"
       ) 
  end

  def activation_instructions(user)
    @account_activation_url = activate_account_url(user.perishable_token)

    mail(:to => user.email,
         :subject => "Activation Instructions"

    ) 
  end

  def activation_confirmation(user)
    mail(:to => user.email,
         :subject => "Activation Complete")
  end

  def member_activation(member)
    @member_activation_link = member_activation_url(member.perishable_token)
    mail(:to => member.email,
       :subject => "Member Activation"
       )
  end

  def member_activation_confirmation(member)
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
    mail(:to => "aru@ongraph.com",
       :subject => "Help Request",
       :from => help.sender_email
       )
  end

end
