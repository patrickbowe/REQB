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
    result=req.find_first_name_email(req)
  end

  def find_user_name_email(req)
    result=req.find_first_name_email(req)
  end

  def find_user_name_comment(comment)
     if !comment.user_id.nil? and !comment.member_id.nil?
        user=Member.find(comment.member_id)
        return first_name=user.first_name
     else !comment.user_id.nil? and comment.member_id.nil?
        user=User.find(comment.user_id)
        address=user.address
        return first_name=address.first_name
     end
  end
  
  def check_attachment_req(id)
    return flag=Requirement.check_attached_req_items(id)
  end

  def add_requirement_usecase(name,req,user)

    link_to_function name do |page|
      page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript(render('requirements/edit_requirement_usecase',:req => req))}');"
      
    end

  end

  def remove_edit_usecase_field(name,req)
        link_to_function name do |page|
          page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript('')}');"

        end
    end
  def add_comment_req_field(name,req,user)
    if req.comments.count==0
        link_to_function name,:title=>"Modify Comments" do |page|
          page << "$('#comment_#{req.id}').html('#{escape_javascript(render('requirements/comment',:req => req,:user=>user))}');"

        end
    else
        link_to_function name,:title=>"Linked comments - #{req.comments.count}" do |page|
          page << "$('#comment_#{req.id}').html('#{escape_javascript(render('requirements/comment',:req => req,:user=>user))}');"

        end
    end
  end

  def find_storage(user)
    if !current_user.nil?
      @user_plan=UserPlan.find_by_user_id (user.id)
    elsif !current_member.nil?
      @user_plan=UserPlan.find_by_user_id(user.user_id)
    end
    return storage=((@user_plan.storage/(1024 * 1024)).to_i)
  end

  def find_total_storage(user)
      if !current_user.nil?
        user_plan=UserPlan.find_by_user_id (user.id)
        @plan=Plan.find(user_plan.plan_id)
      elsif !current_member.nil?
        user_plan=UserPlan.find_by_user_id(user.user_id)
        @plan=Plan.find(user_plan.plan_id)
      end
      return storage=((@plan.storage.to_i/1048576).to_i).to_s
    end

  def add_requirement_file(name,req,user)

    link_to_function name do |page|

       page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript(render('requirements/edit_requirement_file',:req => req))}');"

    end

  end

  def remove_edit_file_field(name,req)
         link_to_function name do |page|
           page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript('')}');"

         end
     end

  def add_requirement_tracker(name,req,user)

    link_to_function name do |page|

       page << "$('#edit_requirement_#{req.id}').html('#{escape_javascript(render('requirements/edit_requirement_tracker',:req => req))}');"
      
    end

  end

  def show_category_list(project_id)
    categories=Category.select("title").where(:project_id=>project_id)
    all_categories=Array.new
    if !categories.empty?
      categories.each do |category|
        all_categories.push(category.title)
      end
    end

   all_categories.push("Create New") 

  end

  def show_delivery_list(project_id)
    deliveries=DeliveryPeriod.select("title").where(:project_id=>project_id)
    all_deliveries=Array.new
    if !deliveries.empty?
      deliveries.each do |delivery|
        all_deliveries.push(delivery.title)
      end
    end

   all_deliveries.push("Create New")
  end

end
