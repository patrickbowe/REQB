Project2::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  #config.action_view.cache_template_loading = true
    
end
module REQBEnv
  DEFAULT_HOST="http://localhost:3000"
  DEFAULT_HOST_WITH_PORT = "localhost:3000"
  DEFAULT_S3_PROFILE_IMAGE_URL = "http://s3.amazonaws.com/REQB/original"
end

