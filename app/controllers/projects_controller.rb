class ProjectsController < ApplicationController
 before_filter :load_object, :only => [:destroy,:edit]
 #To show all projects
  def index
    if !current_user.nil?
      @user=User.find(current_user.id)
      @projects=@user.projects.order("created_at desc")
      @flag=check_project(@user.id)
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      @projects=Project.find(:all, :conditions=>["user_id=? or member_id=?", @user.user_id, @user.id])
      @flag=check_project(@user.user_id)
    else
      redirect_to sign_in_url
    end


  end

  #To create a project
  def create

    if params[:project_name]!=""
      @flag="false"
      if !current_user.nil?
        @user=User.find(current_user.id)
        @user_plan=UserPlan.find_by_user_id(@user.id)
        @flag=check_project(@user.id)
      elsif !current_member.nil?
        @user=Member.find(current_member.id)
        #@user=User.find(@member.user_id)
        @user_plan=UserPlan.find_by_user_id(@user.user_id)
        @flag=check_project(@user.user_id)

      end
      #@project.path=@user_plan.path + "/" + params[:project][:project_name].to_s
      if @flag=="true" and @user.privilige=="Admin"
        if !current_user.nil?
          @project=@user.projects.build(:project_name=>params[:project_name])
        elsif !current_member.nil?
          @project=@user.projects.build(:project_name=>params[:project_name], :user_id=>@user.user_id)
        end
        if @project.save
          @user_plan.update_attributes(:project_count=>@user_plan.project_count + 1)
          if !current_user.nil?
            @attr=@project.create_attribute(:user_id=>@user.id)
            Project.create_notification(@project.id, @user.id)
          elsif !current_member.nil?
            @attr=@project.create_attribute(:member_id=>@user.id, :user_id=>@user.user_id)
            Project.create_notification(@project.id, @user.user_id)
          end
          if session[:project_id].nil?
            session[:project_id]=@project.id
          end
        end
      end


      if !current_user.nil?
        @flag=check_project(@user.id)
      elsif !current_member.nil?
        @flag=check_project(@user.user_id)
      end
    end
    respond_to do |format|
      #format.html { redirect_to requirements_path}
      format.js

    end
  end
  #To edit a project
  def edit
    @user=find_user
    if !@user.nil?
      if @user.privilige=="Admin"
        @project.update_attributes(:project_name=>params[:"project_name_#{@project.id}"], :description=>params[:"project_description_#{@project.id}"])
        redirect_to projects_path
      else
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #To delete a project
  def destroy
    
    @user=find_user
    project_name=@project.project_name
    if !@user.nil?
      if @user.privilige=="Admin"
        
          if session[:project_id].to_i==@project.id
            if @project.destroy
              if !current_user.nil?
                @projects=@user.projects.find :all
              else
                @projects=Project.find(:all, :conditions=>["user_id=? or id=?", @user.user_id, @user.id])
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
              flash[:notice]="#{project_name} was successfully deleted."
            end
          end


        redirect_to projects_path
      else
        flash.now[:notice]="You do not have admin rights."
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end

  end

  #To assign project id into session
  def update_project_name
    #project=Project.find(params[:project_name])
    session[:project_id]=params[:project_id]

  end

 #To check project count
  def check_project(user_id)
    user_plan=UserPlan.find_by_user_id(user_id)
    plan=Plan.find(user_plan.plan_id)
    if plan.project_count > user_plan.project_count
      return flag=true.to_s
    else
      return flag=false.to_s
    end
  end

 #To check that user is either subscriber or member 
  def find_user
    if !current_user.nil?
      user=User.find(current_user.id)
      session[:admin_id]=user.id
      return user
    elsif !current_member.nil?
      user=Member.find(current_member.id)
      session[:admin_id]=user.user_id
      return user
    end

  end

 #To check project exists or not
   def load_object
      unless @project = Project.find_by_id( params[ :id ] )
        redirect_to projects_path
      end
    end
end

