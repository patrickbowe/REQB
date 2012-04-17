class UseCasesController < ApplicationController
  before_filter :store_location, :only => [:show]
  before_filter :load_object, :only => [:destroy, :edit, :show,:edit_req_usecase,:edit_tracker_usecase,:show_req,:edit_usecase_file]

  #To show all use cases corresponding to user
  def index
    @user=find_user
    if !@user.nil?
      assign_project_use
      @use_cases=UseCase.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "created_at desc")
      @attr=Attribute.find_by_project_id(session[:project_id])
    else
      redirect_to sign_in_url
    end
  end

  #To create a use case
  def create
    @user=find_user

    if !@user.nil?
      assign_project_use
      if !params[:use_case_name].empty? and @user.privilige!="Read"
        @project=Project.find(session[:project_id])

        if !current_user.nil?
          @project_use=@project.use_cases.create(:name=>params[:use_case_name], :status=>"Draft", :user_id=>@user.id, :priority=>"Medium", :importance=>"Interesting")
          if !@project_use.id.nil?
            first_name=@project_use.find_user_first_name(current_user.id)
            UseCase.notification_create(current_user.id, @project.id, @project_use, first_name)
          end
        elsif !current_member.nil?
          @project_use=@project.use_cases.create(:name=>params[:use_case_name], :status=>"Draft", :user_id=>@user.user_id, :member_id=>@user.id, :priority=>"Medium", :importance=>"Interesting")
          if !@project_use.id.nil?
            first_name=@project_use.find_member_first_name(@user.id)
            UseCase.notification_create(@user.user_id, @project.id, @project_use, first_name)
          end
        end

        respond_to do |format|
          @attr=Attribute.find_by_project_id(session[:project_id])
          format.js

        end
      end
    end
  end


  def edit

    status=@use_case.status
    @user=find_user
    if !@user.nil?
      if ((status!="Approved" and params[:use_case][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Approve")) or (status!="Approved" and params[:use_case][:status]!="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Read/Write" or @user.privilige=="Approve")) or (status=="Approved" and @user.privilige=="Admin") or (status=="Approved" and params[:use_case][:status]=="Approved" and !params[:use_case][:delivered].empty? and @user.privilige!="Read"))
        if @use_case.update_attributes(params[:use_case])

          if !params[:use_case][:status].nil?
            if (status!="Approved" and params[:use_case][:status]=="Approved")

              if !current_user.nil?
                first_name=@use_case.find_user_first_name(current_user.id)
                UseCase.notification_approved(current_user.id, @use_case.project_id, @use_case, first_name)
              elsif !current_member.nil?
                first_name=@use_case.find_member_first_name(@user.id)
                UseCase.notification_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
              end
            elsif (status!="For Review" and params[:use_case][:status]=="For Review")

              if !current_user.nil?
                first_name=@use_case.find_user_first_name(current_user.id)
                UseCase.notification_reviewed(current_user.id, @use_case.project_id, @use_case, first_name)
              elsif !current_member.nil?
                first_name=@use_case.find_member_first_name(@user.id)
                UseCase.notification_reviewed(@user.user_id, @use_case.project_id, @use_case, first_name)
              end
            elsif (status=="Approved" and params[:use_case][:status]!="Approved")

              if !current_user.nil?
                first_name=@use_case.find_user_first_name(current_user.id)
                UseCase.notification_no_approved(current_user.id, @use_case.project_id, @use_case, first_name)
              elsif !current_member.nil?
                first_name=@use_case.find_member_first_name(@user.id)
                UseCase.notification_no_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
              end

            end
          end
          redirect_to use_cases_path
        else
          
          redirect_to :back
        end
      else
        flash[:notice]= t(:use_case_no_approve)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #To delete an usecase
  def destroy
    @user=find_user
    if !@user.nil?
      reqs=@use_case.requirements.find :all
      if @user.privilige=="Admin" and @use_case.status=="Approved"
        if @use_case.destroy
          delete_req(reqs)
          flash[:notice]="Use case#{params[:id]} was successfully deleted"
          redirect_to use_cases_path
        else
          redirect_to :back
        end
      elsif !current_user.nil? and @user.id==@use_case.user_id and @use_case.status!="Approved" and (@user.privilige!="Read")
        if @use_case.destroy
          delete_req(reqs)
          flash[:notice]="Use case#{params[:id]} was successfully deleted"
          redirect_to use_cases_path
        else
          redirect_to :back
        end
      elsif !current_member.nil? and @user.id==@use_case.member_id and @use_case.status!="Approved" and (@user.privilige!="Read")
        if @use_case.destroy
          delete_req(reqs)
          flash[:notice]="Use case#{params[:id]} was successfully deleted"
          redirect_to use_cases_path
        else
          redirect_to :back
        end
      else
        flash[:notice]=t(:requirement_delete_message_with_out_permisson)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #To show an use case
  def show

    respond_to do |format|
      if current_user.nil? and current_member.nil?
        session[:project_id]=@use_case.project_id
        format.html { redirect_to sign_in_url }
      else
        @user=find_user
        @attr=Attribute.find_by_project_id(session[:project_id])
        format.html { render "show" }
      end
    end
  end

  #To match use case by name
  def match_usecase_name

    use_case1=params[:char]
    @user=find_user
    if !@user.nil?
      assign_project_use
      @use_case=UseCase.find(:all, :conditions=>["name ILIKE ? and project_id= ?", "#{use_case1}%", session[:project_id]])
      respond_to do |format|
        format.js { render :json=> @use_case }
      end
    end
  end

  #Linked an usecase with a given requirement

  def req_create
    @user=find_user
    if !@user.nil?
      assign_project_use
      @project_use1=UseCase.find(:all, :conditions=>["name ILIKE ? and project_id= ?", params[:use_case_name], session[:project_id]])
      if !@project_use1.empty?
        if !session[:req_id].nil?
          @req=Requirement.find(session[:req_id])
          flag=UseCase.find_link_req_use(@req, @project_use1[0])
          if flag==false
            UseCase.insert_req_use(@req, @project_use1[0])
            @project_use=@project_use1[0]
          end
        end

      end

      respond_to do |format|
        @attr=Attribute.find_by_project_id(session[:project_id])
        format.js
      end
    end
  end

  #Edit linked an usecase
  def edit_req_usecase
    @user=find_user
    if !@user.nil?

      status=@use_case.status
      if ((status!="Approved" and params[:use_case][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Approve")) or (status!="Approved" and params[:use_case][:status]!="Approved" and (@user.privilige!="Read")) or (status=="Approved" and @user.privilige=="Admin")or (status=="Approved" and params[:use_case][:status]=="Approved" and !params[:use_case][:delivered].empty? and @user.privilige!="Read"))
        @use_case.update_attributes(params[:use_case])

        if !params[:use_case][:status].nil?
          if (status!="Approved" and params[:use_case][:status]=="Approved")

            if !current_user.nil?
              first_name=@use_case.find_user_first_name(@user.id)
              UseCase.notification_approved(current_user.id, @use_case.project_id, @use_case, first_name)
            else
              first_name=@use_case.find_member_first_name(@user.id)
              UseCase.notification_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
            end
          elsif (status!="For Review" and params[:use_case][:status]=="For Review")

            if !current_user.nil?
              first_name=@use_case.find_user_first_name(current_user.id)
              UseCase.notification_reviewed(current_user.id, @use_case.project_id, @use_case, first_name)
            else
              first_name=@use_case.find_member_first_name(@user.id)
              UseCase.notification_reviewed(@user.user_id, @use_case.project_id, @use_case, first_name)
            end
          elsif (status=="Approved" and params[:use_case][:status]!="Approved")

            if !current_user.nil?
              first_name=@use_case.find_user_first_name(current_user.id)
              UseCase.notification_no_approved(current_user.id, @use_case.project_id, @use_case, first_name)
            else
              first_name=@use_case.find_member_first_name(@user.id)
              UseCase.notification_no_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
            end
          end
        end
        respond_to do |format|
          assign_project_use
          @attr=Attribute.find_by_project_id(session[:project_id])
          @requirement=Requirement.find(session[:req_id])
          if !@requirement.nil?
            format.html { redirect_to show_usecases_url(@requirement.id) }
          else
            format.html { redirect_to requirements_path }
          end
        end

      else
        assign_project_use
        @attr=Attribute.find_by_project_id(session[:project_id])
        flash[:notice]= t(:use_case_no_approve)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #Unlinked an usecase with a given requirement
  def destroy_req_usecase
    find_user
    if !@user.nil?
      req=Requirement.find_by_id(session[:req_id])
      if !session[:req_id].nil? and !req.nil?
        @use_case=UseCase.find(params[:id])
        if !@use_case.nil? and @user.privilige!="Read"
          @use_case.requirements.delete(req)
        end
        respond_to do |format|
          format.html { redirect_to show_usecases_url(req.id) }
        end
      else
        redirect_to requirements_path
      end
    else
      redirect_to sign_in_url
    end

  end

  #Linked an usecase with a given tracker

  def tracker_create
    @user=find_user
    if !@user.nil?
      assign_project_use
      @project_use1=UseCase.find(:all, :conditions=>["name ILIKE ? and project_id= ?", params[:use_case_name], session[:project_id]])
      if !@project_use1.empty? and @user.privilige!="Read"
        if !session[:tracker_id].nil?
          @tracker=Tracker.find(session[:tracker_id])
          flag=UseCase.find_link_tracker_use(@tracker, @project_use1[0])
          if flag==false
            UseCase.insert_tracker_use(@tracker, @project_use1[0])
            @project_use=@project_use1[0]
          end
        end
      end


      respond_to do |format|
        @attr=Attribute.find_by_project_id(session[:project_id])
        format.js
      end
    end
  end

  #Edit linked an usecase
  def edit_tracker_usecase
    @user=find_user
    if @user.nil?
      status=@use_case.status
      if ((status!="Approved" and params[:use_case][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Approve")) or (status!="Approved" and params[:use_case][:status]!="Approved" and (@user.privilige!="Read")) or (status=="Approved" and @user.privilige=="Admin")or (status=="Approved" and params[:use_case][:status]=="Approved" and !params[:use_case][:delivered].empty? and @user.privilige!="Read"))
        @use_case.update_attributes(params[:use_case])

        if !params[:use_case][:status].nil?
          if (status!="Approved" and params[:use_case][:status]=="Approved")

            if !current_user.nil?
              first_name=@use_case.find_user_first_name(current_user.id)
              UseCase.notification_approved(current_user.id, @use_case.project_id, @use_case, first_name)
            else
              first_name=@use_case.find_member_first_name(@user.id)
              UseCase.notification_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
            end
          elsif (status!="For Review" and params[:use_case][:status]=="For Review")

            if !current_user.nil?
              first_name=@use_case.find_user_first_name(current_user.id)
              UseCase.notification_reviewed(current_user.id, @use_case.project_id, @use_case, first_name)
            else
              first_name=@use_case.find_member_first_name(@user.id)
              UseCase.notification_reviewed(@user.user_id, @use_case.project_id, @use_case, first_name)
            end
          elsif (status=="Approved" and params[:use_case][:status]!="Approved")

            if !current_user.nil?
              first_name=@use_case.find_user_first_name(current_user.id)
              UseCase.notification_no_approved(current_user.id, @use_case.project_id, @use_case, first_name)
            else
              first_name=@use_case.find_member_first_name(@user.id)
              UseCase.notification_no_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
            end
          end
        end
        respond_to do |format|
          @attr=Attribute.find_by_project_id(session[:project_id])
          if !session[:tracker_id].nil?
            @tracker=Tracker.find(session[:tracker_id])
            format.html { redirect_to show_tracker_use_url(@tracker.id) }
          else
            format.html { redirect_to trackers_path }
          end
        end

      else
        @attr=Attribute.find_by_project_id(session[:project_id])
        flash[:notice]= t(:use_case_no_approve)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #Unlinked an usecase with a given tracker
  def destroy_tracker_usecase
    find_user
    if !@user.nil?
      if !session[:tracker_id].nil?
        tracker=Tracker.find_by_id(session[:tracker_id])
        @use_case=UseCase.find(params[:id])
        if !@use_case.nil? and @user.privilige!="Read" and !tracker.nil?
          @use_case.trackers.delete(tracker)
          respond_to do |format|
            format.html { redirect_to show_tracker_use_url(tracker.id) }
          end
        else
          redirect_to trackers_path
        end
      else
        redirect_to trackers_path
      end
    else
      redirect_to sign_in_url
    end

  end

  #To show requirements corresponding to a use case
  def show_req
    @user=find_user
    if !@user.nil?
      @use_reqs=@use_case.requirements.find :all
      session[:use_case_id]=@use_case.id
      @attr=Attribute.find_by_project_id(session[:project_id])
      respond_to do |format|
        format.html { render "requirements/index" }
      end
    else
      redirect_to sign_in_url
    end

  end

  #To show all trackers corresponding to use case
  def show_tracker_use
    find_user
    if !@user.nil?
      assign_project_use
      @use= UseCase.find_by_id(params[:use])
      if !@use.nil?
        @all_user=Tracker.find_all_user(@user)
        @tracker_usecases=Tracker.find_tracker_by_req(@use)
        #@tracker_reqs=req.trackers.find(:all,:order => "updated_at desc")
        session[:use_case_id]=@use.id
        respond_to do |format|
          format.html { render "trackers/index" }
        end
      else
         redirect_to use_cases_path
      end
    else
      redirect_to sign_in_url
    end

  end

  #To create a comment
  def create_comment
    @user=find_user
    @use=UseCase.find_by_id(params[:id])
    if !current_user.nil? and !@use.nil?
      @comment=@use.comments.create(:title=>params[:comment], :user_id=>@user.id)
    elsif !current_member.nil? and !@use.nil?
      @comment=@use.comments.create(:title=>params[:comment], :user_id=>@user.user_id, :member_id=>@user.id)
    end

    respond_to do |format|
      format.js
    end
  end

  #To delete a comment
  def delete_comment
    @comment=Comment.find_by_id(params[:id])
    @comment1=@comment
    if !@comment.nil?
      @comment.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  #To update a comment
  def update_use_comment
    if params[:commit]=="Save"
      params[:comment].each { |key, value|
        comment=Comment.find(:all, :conditions=>["id=?", key])
        if !comment.empty?
          comment[0].update_attributes(:title=>value)
        end
      }
    elsif   params[:commit]=="Cancel"
      params[:comment].each { |key, value|
        comment=Comment.find(key)
        if !comment.nil?
          comment.destroy
        end
      }
    end
    redirect_to use_cases_path
  end


  #show files that are linked to an usecase
  def show_file_use
    @user=find_user
    @use_case = UseCase.find_by_id(params[:use])
    if !@user.nil?
      assign_project_use
      if !current_user.nil?
        @flag=check_storage(@user.id)
      elsif !current_member.nil?
        @flag=check_storage(@user.user_id)
      end
      @file_uses=@use_case .project_files.find :all
      @file_use1=ProjectFile.new
      session[:use_case_id]=@use_case.id
      respond_to do |format|
        format.html { render "project_files/index" }
      end
    else
      redirect_to sign_in_url
    end

  end

  #To sort use cases corresponding to name,type and entered date
  def sort_usecase
    @user=find_user
    if !@user.nil?
      assign_project_use
      if params[:name]=="created_at"
        @use_cases=UseCase.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]} desc")
      else
        @use_cases=UseCase.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]}")
      end
      @attr=Attribute.find_by_project_id(session[:project_id])
    end
  end

#Linked a use case with  given an file
  def create_usecase_file
    find_user
    if !@user.nil?
      assign_project_use
      if !params[:usecase].empty?
        @usecase1=UseCase.find(:all, :conditions=>["name ILIKE ?", params[:usecase]])
        if !@usecase1.empty? and @user.privilige!="Read"
          if !session[:file_id].nil?
            @file=ProjectFile.find(session[:file_id])
            flag=UseCase.find_link_use_file(@file, @usecase1[0])
            if flag==false
              UseCase.insert_use_file(@file, @usecase1[0])
              @file_use=@usecase1[0]
            end
          end
        end

      end
      @attr=Attribute.find_by_project_id(session[:project_id])


    end
    respond_to do |format|
      format.js
    end
  end

  #Unlinked a use case with a given file
  def destroy_usecase_file
    @user=find_user
    if !@user.nil?
      @file_use=UseCase.find_by_id(params[:id])
      if !session[:file_id].nil?
        @file=ProjectFile.find(session[:file_id])
        if !@file.nil? and @user.privilige!="Read" and !@file_use.nil?
          @file_use.project_files.delete(@file)
          respond_to do |format|
            format.html { redirect_to show_file_uses_url(@file.id) }
          end
        else
          redirect_to project_files_path
        end
      else
        redirect_to project_files_path
      end
    else
      redirect_to sign_in_url
    end

  end

  #Edit linked use case
  def edit_usecase_file
    find_user
    if !@user.nil?
      status=@use_case.status
      if ((status!="Approved" and params[:use_case][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Approve" or @user.privilige=="Read/Write/Approve")) or (status!="Approved" and params[:use_case][:status]!="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Approve")) or (status=="Approved" and @user.privilige=="Admin")or (status=="Approved" and params[:use_case][:status]=="Approved" and !params[:use_case][:delivered].empty? and @user.privilige!="Read"))
        if @use_case.update_attributes(params[:use_case])
          if (!params[:use_case][:status].nil?)

            if (status!="Approved" and params[:use_case][:status]=="Approved")

              if !current_user.nil?
                first_name=@use_case.find_user_first_name(current_user.id)
                UseCase.notification_approved(current_user.id, @use_case.project_id, @use_case, first_name)
              else
                first_name=@use_case.find_member_first_name(@user.id)
                UseCase.notification_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
              end
            elsif (status!="For Review" and params[:use_case][:status]=="For Review")

              if !current_user.nil?
                first_name=@use_case.find_user_first_name(current_user.id)
                UseCase.notification_reviewed(current_user.id, @use_case.project_id, @use_case, first_name)
              else
                first_name=@use_case.find_member_first_name(current_user.id)
                UseCase.notification_reviewed(@user.user_id, @use_case.project_id, @use_case, first_name)
              end
            elsif (status=="Approved" and params[:use_case][:status]!="Approved")
              find_user
              if !current_user.nil?
                first_name=@use_case.find_user_first_name(current_user.id)
                UseCase.notification_no_approved(current_user.id, @use_case.project_id, @use_case, first_name)
              else
                first_name=@use_case.find_member_first_name(@user.id)
                UseCase.notification_no_approved(@user.user_id, @use_case.project_id, @use_case, first_name)
              end
            end
          end

        end
        @attr=Attribute.find_by_project_id(session[:project_id])
        if !session[:file_id].nil?
          @file=ProjectFile.find(session[:file_id])
          redirect_to show_file_uses_url(@file.id)
        else
          redirect_to project_files_path
        end

      else


        flash[:notice]= t(:usecase_edit_message_with_out_permisson)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  private
  #To check whether an user is subscriber or member
  def find_user
    if !current_user.nil?
      @user=User.find(current_user.id)
      session[:admin_id]=@user.id
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      session[:admin_id]=@user.user_id
    end
    return @user
  end

  #To assign project id into session
  def assign_project_use
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

  #To delete requirments
  def delete_req(reqs)

    if !reqs.nil?
      reqs.each do |req|
        requirement=Requirement.find(req.id)
        if !requirement.nil?
          requirement.destroy
        end
      end
    end
  end

  #To check storage limit
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

  #To check use case exists or not
  def load_object
    unless @use_case = UseCase.find_by_id(params[:id])
      redirect_to use_cases_path
    end
  end

end
