class ProjectsController < ApplicationController

  def index
    if !current_user.nil?
       @user=User.find(current_user.id)
       @projects=@user.projects.order("created_at desc")
       @flag=check_project(@user.id)
    else
       @user=Member.find(current_member.id)
       @projects=Project.find(:all,:conditions=>["user_id=? or id=?",@user.user_id,@user.id])
       @flag=check_project(@user.user_id)
    end



  end


  def create

    if !current_user.nil?
       @user=User.find(current_user.id)
       @user_plan=UserPlan.find_by_user_id(@user.id)
       @flag=check_project(@user.id)
    else
       @user=Member.find(current_member.id)
       #@user=User.find(@member.user_id)
       @user_plan=UserPlan.find_by_user_id(@user.user_id)
       @flag=check_project(@user.user_id)
   end

    #@project.path=@user_plan.path + "/" + params[:project][:project_name].to_s

    if @flag=="true" and @user.privilige=="Admin"
      if !current_user.nil?
        @project=@user.projects.build(:project_name=>params[:project_name])
      else
        @project=@user.projects.build(:project_name=>params[:project_name],:user_id=>@user.user_id)
      end
      if @project.save
         @user_plan.update_attributes(:project_count=>@user_plan.project_count + 1)
         if session[:project_id].nil?
             session[:project_id]=@project.id
         end
      end  
    end  


    if !current_user.nil?
      @flag=check_project(@user.id)
    else
      @flag=check_project(@user.user_id)
    end
    respond_to do |format|
        #format.html { redirect_to requirements_path}
        format.js

    end
   end

  def edit
      @user=find_user
      if @user.privilige=="Admin" 
          @project=Project.find(params[:id])
          @project.update_attributes(:project_name=>params[:project_name],:description=>params[:description])
          redirect_to projects_path
      else
           redirect_to :back
      end

  end

  def destroy
    @project=Project.find(params[:id])
    @user=find_user
    
   if @user.privilige=="Admin"
   if session[:project_id].to_i==@project.id
     if @project.destroy
        if !current_user.nil?
           @projects=@user.projects.find :all
        else
           @projects=Project.find(:all,:conditions=>["user_id=? or id=?",@user.user_id,@user.id])
        end
        if !@projects.empty?
            session[:project_id]=@projects[0].id
          else
            session[:project_id]=nil
        end
        if !current_user.nil?
            @user_plan=UserPlan.find_by_user_id(current_user.id)
            @user_plan.update_attributes(:project_count=>@user_plan.project_count - 1)
         else
            @user_plan=UserPlan.find_by_user_id(@user.user_id)
            @user_plan.update_attributes(:project_count=>@user_plan.project_count - 1)
         end
     end
   else
      if @project.destroy
         if !current_user.nil?
            @user_plan=UserPlan.find_by_user_id(current_user.id)
            @user_plan.update_attributes(:project_count=>@user_plan.project_count - 1)
         else
            @user_plan=UserPlan.find_by_user_id(@user.user_id)
            @user_plan.update_attributes(:project_count=>@user_plan.project_count - 1)
         end
      end
    end
     redirect_to projects_path

   else
        flash.now[:notice]="You do not have admin rights."
        redirect_to :back
    end

  end


  def update_project_name
    #project=Project.find(params[:project_name])
    session[:project_id]=params[:project_id]
    
  end

  def check_project(user_id)
    user_plan=UserPlan.find_by_user_id(user_id)
    plan=Plan.find(user_plan.plan_id)
    if plan.project_count > user_plan.project_count
      return flag=true.to_s
    else
      return flag=false.to_s
    end
  end

   def find_user
      if !current_user.nil?
        user=User.find(current_user.id)
      else
        user=Member.find(current_member.id)
      end
      return user
    end
end

