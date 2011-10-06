module UseCasesHelper
  def add_use_edit_field(name,use_case,user)

    link_to_function name do |page|
      if user.privilige!="Read" and user.privilige!="Approve"
       page << "$('#edit_#{use_case.id}').html('#{escape_javascript(render('use_cases/edit',:u => use_case))}');"
      end  
    end

  end

  def add_use_req_edit_field(name,use_case)
      link_to_function name do |page|
        page << "$('#edit_#{use_case.id}').html('#{escape_javascript(render('use_cases/edit_req',:u => use_case))}');"

      end
  end

  def remove_use_edit_field(name,use_case)
      link_to_function name do |page|
        page << "$('#edit_#{use_case.id}').html('#{escape_javascript('')}');"

      end
  end

  def remove_use_req_edit_field(name,use_case)
        link_to_function name do |page|
          page << "$('#edit_#{use_case.id}').html('#{escape_javascript('')}');"

        end
    end

   def find_user_name_use(u)
    result=u.find_user_name_use
   end

  def add_usecase_detail(name,usecase)
       link_to_function name do |page|
         page << "$('#require').html('#{escape_javascript(render('use_case_details/index'))}');"

       end
  end

def check_attachment_use(id)
    return flag=UseCase.check_attached_items(id)
 end

  def add_comment_use_field(name,use,user)
          link_to_function name,:title=>use.comments.count do |page|
            page << "$('#comment_#{use.id}').html('#{escape_javascript(render('use_cases/comment',:use => use,:user=>user))}');"

          end
      end

  def find_storage_use(user)
        if !current_user.nil?
          user_plan=UserPlan.find_by_user_id (user.id)
        elsif !current_member.nil?
          user_plan=UserPlan.find_by_user_id(user.user_id)
        end
        return storage=((user_plan.storage/1048576).to_f)
      end

      def find_total_storage_use(user)
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
