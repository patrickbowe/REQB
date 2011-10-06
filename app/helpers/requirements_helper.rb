module RequirementsHelper

  def add_edit_field(name,req)
      link_to_function name do |page|
        page << "$('#edit_#{req.id}').html('#{escape_javascript(render('edit',:req => req))}');"

      end
  end

  def remove_edit_field(name,req)
      link_to_function name do |page|
        page << "$('#edit_#{req.id}').html('#{escape_javascript('')}');"

      end
  end

  def add_require(name)
       link_to_function name do |page|
         page << "$('#require').html('#{escape_javascript(render(:partial=>'add_require'))}');"

       end
  end

  def find_user_name(req)
    result=req.find_user_name_req
  end

  def check_attachment_req(id)
    return flag=Requirement.check_attached_req_items(id)
  end

  def add_requirement_usecase(name,req,user)

    link_to_function name do |page|
      if user.privilige!="Read" and user.privilige!="Approve"
       page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript(render('requirements/edit_requirement_usecase',:req => req))}');"
      end
    end

  end

  def remove_edit_usecase_field(name,req)
        link_to_function name do |page|
          page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript('')}');"

        end
    end
  def add_comment_req_field(name,req,user)
        link_to_function name,:title=>req.comments.count do |page|
          page << "$('#comment_#{req.id}').html('#{escape_javascript(render('requirements/comment',:req => req,:user=>user))}');"

        end
    end

  def find_storage(user)
    if !current_user.nil?
      user_plan=UserPlan.find_by_user_id (user.id)
    elsif !current_member.nil?
      user_plan=UserPlan.find_by_user_id(user.user_id)
    end
    return storage=((user_plan.storage/(1024 * 1024)).to_f) 
  end

  def find_total_storage(user)
      if !current_user.nil?
        user_plan=UserPlan.find_by_user_id (user.id)
        plan=Plan.find(user_plan.plan_id)
      elsif !current_member.nil?
        user_plan=UserPlan.find_by_user_id(user.user_id)
        plan=Plan.find(user_plan.plan_id)
      end
      return storage=plan.storage
    end

end
