module HomesHelper

  def add_change_password_field(name,current_user)
      link_to_function name do |page|
        page << "$('#change_password').html('#{escape_javascript(render('users/change_password',:user => current_user))}');"

      end
  end

  def add_change_email_field(name,current_user)
        link_to_function name do |page|
              page << "$('#change_email').html('#{escape_javascript(render('users/change_email',:object=>{:user => current_user}))}');"

        end
  end

  def add_change_email_member_field(name,current_member)
          link_to_function name do |page|
                page << "$('#change_email').html('#{escape_javascript(render('members/change_email',:member => current_member))}');"

          end
   end

  def update_change_subscription(name,current_user)
        link_to_function name do |page|
          page << "$('#update_subscription').html('#{escape_javascript(render('users/update_subscription',:user => current_user))}');"

        end
    end


end
