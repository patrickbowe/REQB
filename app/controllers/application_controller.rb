class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user,:current_member_session,:current_member

	  private
	    def current_user_session
	      logger.debug "ApplicationController::current_user_session"
	      return @current_user_session if defined?(@current_user_session)
          @current_user_session = UserSession.find
       end

       def current_member_session
                   logger.debug "ApplicationController::member_user_session"
                   return @current_member_session if defined?(@current_member_session)
                   @current_member_session = MemberSession.find
       end

	    def current_user
	      logger.debug "ApplicationController::current_user"
	      return @current_user if defined?(@current_user)
          @current_user = current_user_session && current_user_session.user
        end

       def current_member
            logger.debug "ApplicationController::current_member"
            return @current_member if defined?(@current_member)
            @current_member = current_member_session && current_member_session.member
       end


	    def require_user
	      logger.debug "ApplicationController::require_user"
	      unless current_user and current_member
	        store_location
	        flash[:notice] = "You must be logged in to access this page"
	        redirect_to new_user_session_url
	        return false
	      end
	    end

	    def require_no_user
	      logger.debug "ApplicationController::require_no_user"
	      if current_user and current_member
	        store_location
	        flash[:notice] = "You must be logged out to access this page"
	        redirect_to account_url
	        return false
	      end
	    end

	    def store_location
	      session[:return_to] = request.request_uri
	    end

	    def redirect_back_or_default(default)
	      redirect_to(session[:return_to] || default)
	      session[:return_to] = nil
        end

end
