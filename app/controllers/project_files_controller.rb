require "aws/s3"
class ProjectFilesController < ApplicationController
  before_filter :store_location, :only => [:show]
  before_filter :load_object, :only => [:destroy, :edit, :show,:destroy_file_req,:edit_file_req,:destroy_file_use,:edit_file_use,:show_req,:show_use]

  #To show all files corresponding to user
  def index
    find_user
    if !@user.nil?
      assign_project
      #@project=Project.find(session[:project_id])
      @files=ProjectFile.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "created_at desc")
      @file=ProjectFile.new
      if !current_user.nil?
        @flag=check_storage(@user.id)
      else
        @flag=check_storage(@user.user_id)
      end
    else
      redirect_to sign_in_url
    end
  end

  #To create a file
  def create
    find_user
    if !@user.nil?
      assign_project
      @project=Project.find(session[:project_id])
      if !current_user.nil?
        @flag1=check_storage_before(@user.id, params[:project_file])
      else
        @flag1=check_storage_before(@user.user_id, params[:project_file])
      end
      @file_size=params[:project_file][:file].size
      if @flag1=="false"
        @file = @project.project_files.create(params[:project_file])
        if !current_user.nil?
          @file.update_attributes(:user_id=>@user.id, :type1=> "Document")
          ProjectFile.notification_create(current_user.id, @project.id, @file)
        else
          @file.update_attributes(:user_id=>@user.user_id, :member_id=>@user.id, :type1=> "Document")
          ProjectFile.notification_create(@user.user_id, @project.id, @file)
        end
        user_plan=UserPlan.find_all_by_user_id(@file.user_id)
        user_plan[0].update_attributes(:storage=>user_plan[0].storage + @file.file_file_size)

      else
        flash[:message]="You don't have enough space and offer you the chance to upgrade"
      end
      redirect_to project_files_path
    else
      redirect_to sign_in_url
    end
  end

  #To create destroy a file
  def destroy
    find_user
    if !@user.nil?
      if (!@file.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@file.user_id) or (!current_member.nil? and @user.id==@file.member_id)))
        storage1=@file.file_file_size.to_i
        @file.file.destroy
        if !current_user.nil?
          user_plan=UserPlan.find_by_user_id(@user.id)
        else
          user_plan=UserPlan.find_by_user_id(@user.user_id)
        end
        @file.destroy
        user_plan.update_attributes(:storage=>user_plan.storage-storage1)
      else
        flash[:notice]=t(:file_no_user)
      end
      redirect_to project_files_path
    else
      redirect_to sign_in_url
    end
  end

  #To edit a file
  def edit

    if !@file.nil?
      @file.update_attributes(:type1=>params[:type1][0], :description=>params[:des])
    end
    redirect_to project_files_path
  end

  #To show a file
  def show

    respond_to do |format|
      if current_user.nil? and current_member.nil?
        session[:project_id]=@file.project_id
        format.html { redirect_to sign_in_url }
      else
        find_user
        format.html { render "show" }
      end
    end
  end

  # create a comment that are related to file
  def create_comment
    @file=ProjectFile.find_by_id(params[:id])
    find_user
    if !current_user.nil? and !@file.nil?
      @comment=@file.comments.create(:title=>params[:comment], :user_id=>@user.id)
    elsif  !current_member.nil? and !@file.nil?
      @comment=@file.comments.create(:title=>params[:comment], :user_id=>@user.user_id, :member_id=>@user.id)
    end

    respond_to do |format|
      format.js
    end
  end

  #To delete a comment
  def delete_comment
    @comment=Comment.find(params[:id])
    @comment1=@comment
    if !@comment.nil?
      @comment.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  #To update a comment
  def update_file_comment
    if params[:commit]=="Save"
      params[:comment].each { |key, value|
        comment=Comment.find(key)
        comment.update_attributes(:title=>value)
      }
    elsif   params[:commit]=="Cancel"
      params[:comment].each { |key, value|
        comment=Comment.find(key)
        if !comment.nil?
          comment.destroy
        end
      }
    end
    redirect_to project_files_path
  end


  #show matched file name
  def match_file_name
    find_user
    if !@user.nil?
      assign_project
      file1=params[:char]
      @files=ProjectFile.find(:all, :conditions=>["file_file_name ILIKE ? and project_id=?", "#{file1}%", session[:project_id]])
      respond_to do |format|
        format.js { render :json=> @files }
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  #Linked a file with a requirement
  def create_link_req
    @file1=ProjectFile.find(:all, :conditions=>["file_file_name LIKE ?", params[:file_name].to_s+'.'+params[:ext1]])
    @req=Requirement.find(session[:req_id])
    #@req.project_files
    if !session[:req_id].nil?
      if !@file1.nil?
        #@file1[0].requirements.all
        if !@file1.empty?
          flag=ProjectFile.find_link_req(@req, @file1[0])
          if flag==false
            ProjectFile.insert_req_file(@req, @file1[0])
            @file=@file1[0]
          end
        end
      end
      find_user
    end
    respond_to do |format|
      format.js
    end
  end

  #To crate a file that will be linked with a requirement
  def create_req_file
    @req=Requirement.find_by_id(session[:req_id])
    if !session[:req_id].nil? and !@req.nil?

      find_user
      if !@user.nil?
        @flag1=check_storage_before(@user.id, params[:project_file])
        @file_size=params[:project_file][:file].size
        if @flag1=="false"
          @file = @req.project_files.create(params[:project_file])
          if !current_user.nil?
            @file.update_attributes(:user_id=>@user.id, :type1=> "Document", :project_id=>@req.project_id)
            ProjectFile.notification_create(current_user.id, @req.project_id, @file)
          else
            @file.update_attributes(:user_id=>@user.user_id, :member_id=>@user.id, :type1=> "Document", :project_id=>@req.project_id)
            ProjectFile.notification_create(@user.user_id, @req.project_id, @file)
          end
          user_plan=UserPlan.find_all_by_user_id(@file.user_id)
          user_plan[0].update_attributes(:storage=>user_plan[0].storage + @file.file_file_size)

        else
          flash[:message]="You don't have enough space and offer you the chance to upgrade"
        end
        @file_reqs=@req.project_files.find :all
        redirect_to show_files_url(:req=>@req.id)
      else
        redirect_to sign_in_url
      end
    else
      redirect_to project_files_url
    end
  end

#Unlink a file with a requirement
  def destroy_file_req
    find_user
    if !@user.nil?
      if !session[:req_id].nil?
        @req=Requirement.find(session[:req_id])
        if (!@file.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@file.user_id) or (!current_member.nil? and @user.id==@file.member_id)))
          @file.requirements.delete(@req)
          @file.destroy
        else
          flash[:notice]=t(:file_no_user)
        end
        redirect_to show_files_url(session[:req_id])
      else
        redirect_to project_files_url
      end
    else
      redirect_to sign_in_url
    end
  end

  #Edit linked file with a requirement
  def edit_file_req

    find_user
    if !@user.nil?
      if !@file.nil?
        @file.update_attributes(:type1=>params[:type1][0], :description=>params[:des])
      end
      @file_req1=ProjectFile.new
      if !session[:req_id].nil?
        redirect_to show_files_url(session[:req_id])
      else
        redirect_to project_files_url
      end
    else
      redirect_to sign_in_url
    end
  end

  #Linked a file with a usecase
  def create_link_use
    @file1=ProjectFile.find(:all, :conditions=>["file_file_name LIKE ?", params[:file_name].to_s+'.'+params[:ext1]])
    @use=UseCase.find_by_id(session[:use_case_id])
    if !@use.nil?
      if !@file1.nil?
        if !@file1.empty?
          flag=ProjectFile.find_link_use(@use, @file1[0])
          if flag==false
            ProjectFile.insert_use_file(@use, @file1[0])
            @file=@file1[0]
          end
        end
      end
    end
    find_user
    respond_to do |format|
      format.js
    end
  end

  #To create a file that will be linked with given use case
  def create_use_file
    find_user
    if !@user.nil?
      @use=UseCase.find_by_id(session[:use_case_id])
      if !session[:use_case_id].nil? and !@use.nil?
        @flag1=check_storage_before(@user.id, params[:project_file])
        @file_size=params[:project_file][:file].size
        if @flag1=="false"
          @file = @use.project_files.create(params[:project_file])
          if !current_user.nil?
            @file.update_attributes(:user_id=>@user.id, :type1=> "Document", :project_id=>@use.project_id)
            ProjectFile.notification_create(current_user.id, @use.project_id, @file)
          else
            @file.update_attributes(:user_id=>@user.user_id, :member_id=>@user.id, :type1=> "Document", :project_id=>@use.project_id)
            ProjectFile.notification_create(@user.user_id, @use.project_id, @file)
          end
          user_plan=UserPlan.find_all_by_user_id(@file.user_id)
          user_plan[0].update_attributes(:storage=>user_plan[0].storage + @file.file_file_size)

        else
          flash[:message]="You don't have enough space and offer you the chance to upgrade"

        end
        @file_uses=@use.project_files.find :all
        redirect_to show_files_use_url(session[:use_case_id])
      else
        redirect_to project_files_url
      end
    else
      redirect_to sign_in_url
    end
  end


#Unlink a file with a usecase
  def destroy_file_use
    find_user
    if !@user.nil?

      if !session[:use_case_id].nil?
        @use=UseCase.find(session[:use_case_id])
        if (!@file.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@file.user_id) or (!current_member.nil? and @user.id==@file.member_id)))
          @file.use_cases.delete(@use)
          @file.destroy
        else
          flash[:notice]=t(:file_no_user)
        end

        redirect_to show_files_use_url(session[:use_case_id])
      else
        redirect_to project_files_url
      end
    else
      redirect_to sign_in_url
    end
  end

  #Edit linked file with a usecase
  def edit_file_use

    find_user
    if !@file.nil?
      @file.update_attributes(:type1=>params[:type1][0], :description=>params[:des])
    end
    if !session[:use_case_id].nil?
      redirect_to show_files_use_url(session[:use_case_id])
    else
      redirect_to project_files_url
    end
  end

  #To sort all files by name,type or entered date
  def sort_file
    find_user
    if !@user.nil?
      assign_project
      if params[:name]=="created_at"
        @files=ProjectFile.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]} desc")
      else
        @files=ProjectFile.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]}")
      end
      if !current_user.nil?
        @flag=check_storage(@user.id)
      else
        @flag=check_storage(@user.user_id)
      end
    end
  end

  #To show all requirements related to file
  def show_req

    @file_reqs=@file.requirements.find :all
    find_user
    if !@user.nil?
      assign_project
      @attr=Attribute.find_by_project_id(session[:project_id])
      session[:file_id]=@file.id
      respond_to do |format|
        format.html { render "requirements/index" }
      end
    else
      redirect_to sign_in_url
    end

  end

  #To show all requirements related to file
  def show_use

    @file_use_cases=@file.use_cases.find :all
    find_user
    if !@user.nil?
      assign_project
      @attr=Attribute.find_by_project_id(session[:project_id])
      session[:file_id]=@file.id
      respond_to do |format|
        format.html { render "use_cases/index" }
      end
    else
      redirect_to sign_in_url
    end

  end

  private
  #To assign project id into session
  def assign_project
    if !session[:project_id].nil?
      find_project=Project.find_by_id(session[:project_id])
      if find_project.nil?
        project=Project.assign_project_id(session[:admin_id])
        if !project.empty?
          session[:project_id]=project[0].id
        end
      end
    else
      project=Project.assign_project_id(session[:admin_id])
      if !project.empty?
        session[:project_id]=project[0].id
      end
    end
  end

  #To check user is either subscriber or member
  def find_user
    if !current_user.nil?
      @user=User.find(current_user.id)
      session[:admin_id]=@user.id
    else
      @user=Member.find(current_member.id)
      session[:admin_id]=@user.user_id
    end
  end

  #To check storage limit corresponding to an user
  def check_storage(user_id)
    user_plan=UserPlan.find_by_user_id(user_id)
    plan=Plan.find(user_plan.plan_id)
    storage1=(user_plan.storage/1024*1024).to_f

    if plan.storage.to_i > storage1
      return flag=true.to_s
    else
      return flag=false.to_s
    end
  end

  def check_storage_before(user_id, file)
    user_plan=UserPlan.find_by_user_id(user_id)
    plan=Plan.find(user_plan.plan_id)
    if (file[:file].size.to_i > (plan.storage.to_i - user_plan.storage))
      return flag=true.to_s
    else
      return flag=false.to_s
    end

  end

  #To check file exists or not
  def load_object
    unless @file = ProjectFile.find_by_id(params[:id])
      redirect_to project_files_path
    end
  end
end
