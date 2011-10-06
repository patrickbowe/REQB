ActionMailer::Base.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "gmail.com",
      :user_name            => "ongraph1",
      :password             => "0ngraph1",
      :authentication       => "plain",
      :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = "stormy-day-3719.heroku.com"
#ActionMailer::Base.default_url_options[:host] = "localhost:3000"
