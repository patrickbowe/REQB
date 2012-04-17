ActionMailer::Base.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "requirementbox.com",
      :user_name            => "webmaster@requirementbox.com",
      :password             => "requirem3nt",
      :authentication       => "plain",
      :enable_starttls_auto => true
      
       
}
ActionMailer::Base.default_url_options[:host] = "requirementbox.com"
ActionMailer::Base.default :from => "support@requirementbox.com"
#ActionMailer::Base.default_url_options[:host] = "localhost:3000"
