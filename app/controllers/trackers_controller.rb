class TrackersController < ApplicationController
  before_filter :store_location, :only => [:show]
  before_filter :load_object, :only => [:destroy, :edit, :show,:destroy_tracker_req,:edit_tracker_req,:destroy_tracker_use,:edit_tracker_use,:show_req,:show_use_case]

  #To show all trackers corresponding to user
  def index
    find_user
    if !@user.nil?
      assign_project
      @trackers=Tracker.find_tracker(session[:project_id])
    else
      redirect_to sign_in_url
    end
  end

  #To create a tracker
  def create
    find_user
    if !@user.nil?
      assign_project
      if !params[:tracker_name].empty?
        @project=Project.find(session[:project_id])
        if !current_user.nil?
          @tracker=@project.trackers.create(:title=>params[:tracker_name], :user_id=>@user.id, :flag_tracker=>false, :category=>"Task")
        elsif !current_member.nil?
          @tracker=@project.trackers.create(:title=>params[:tracker_name], :user_id=>@user.user_id, :member_id=>@user.id, :flag_tracker=>false, :category=>"Task")
        end
      end
    end
    respond_to do |format|
      format.js
    end

  end

  #To edit a tracker
  def edit
    find_user
    if !@user.nil?
      tracker_assigned=@tracker.assigned
      if !@tracker.nil?
        date1=params[:due1].split('/')
        if !date1[1].nil?
          @tracker.update_attributes(:category=>params[:category][0], :due=>Date.strptime("{ #{date1[2]}, #{date1[0]}, #{date1[1]} }", "{ %Y, %m, %d }"), :assigned=>params[:assigned][:id], :assigned_subscriber_id=>@subscriber_id, :title=>params[:title])
        else
          @tracker.update_attributes(:category=>params[:category][0], :assigned=>params[:assigned][:id], :assigned_subscriber_id=>@subscriber_id, :title=>params[:title])
        end

        if (!params[:assigned][:id].empty?)
          if (tracker_assigned!=params[:assigned][:id])
            address=Address.find_by_first_name(params[:assigned][:id])
            if !address.nil?
              user=User.find(address.user_id)
              first_name=address.first_name
              @notification=Notification.find(:all, :conditions=>["user_id=? and project_id=?", user.id, @tracker.project_id])
            end

            if user.nil? and address.nil?
              user=Member.find_by_first_name((params[:assigned][:id]))
              if !user.nil?
                first_name=user.first_name
                @notification=Notification.find(:all, :conditions=>["member_id=? and project_id=?", user.id, @tracker.project_id])
              end
            end
            if  !@notification.nil?
              if !@notification.empty? and @notification[0].task_assigned==true
                UserMailer.notification_task_assigned(user, @tracker, first_name).deliver
              end
            end
          end
        end

        if !current_user.nil?
          Tracker.notification_task_modified(current_user.id, @tracker.project_id, @tracker)
        elsif !current_member.nil?
          Tracker.notification_task_modified(@user.user_id, @tracker.project_id, @tracker)
        end
      end
      redirect_to trackers_path
    else
      redirect_to sign_in_url
    end

  end

  #To destroy a tracker
  def destroy
    find_user
    if !@user.nil?
      if (!@tracker.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@tracker.user_id) or (!current_member.nil? and @user.id==@tracker.member_id)))
        @tracker.destroy
      else
        flash[:notice]=t(:tracker_no_user)
      end

      redirect_to trackers_path
    else
      redirect_to sign_in_url
    end
  end

  #To show a tracker
  def show

    respond_to do |format|
      if current_user.nil? and current_member.nil?
        session[:project_id]=@tracker.project_id
        format.html { redirect_to sign_in_url }
      else
        find_user
        assign_project
        format.html { render "show" }
      end
    end
  end

  #To mark a tracker as complete or incomplete
  def tracker_flag
    find_user
    if !@user.nil?
      @tracker=Tracker.find_by_id(params[:id])
      if params[:tracker_flag]=="checked" and !@tracker.nil?
        @tracker.update_attributes(:flag_tracker=>true)
      elsif !@tracker.nil?
        @tracker.update_attributes(:flag_tracker=>false)
      end
      assign_project
      @trackers=Tracker.find_tracker(session[:project_id])
    end

    respond_to do |format|
      format.js

    end
  end

  #To find match tracker
  def match_tracker_name
    find_user
    if !@user.nil?
      assign_project
      tracker1=params[:char]
      @tracker=Tracker.find(:all, :conditions=>["title ILIKE ? and project_id=?", "#{tracker1}%", session[:project_id]])
      respond_to do |format|
        format.js { render :json=> @tracker }
      end
    end

  end

  #Link a tracker to requirement
  def create_tracker_req
    find_user
    if !@user.nil?
      if !session[:req_id].nil?
        @req=Requirement.find_by_id(session[:req_id])
        if !params[:tracker_name].empty?
          if !current_user.nil? and !@req.nil?
            @tracker_req=@req.trackers.create(:title=>params[:tracker_name], :user_id=>@user.id, :flag_tracker=>false, :category=>"Task", :project_id=>@req.project_id)
            if @tracker_req.id.nil?
              respond_to do |format|
                format.js
              end
            end
          elsif !current_member.nil? and !@req.nil?
            @tracker_req=@req.trackers.create(:title=>params[:tracker_name], :user_id=>@user.user_id, :member_id=>@user.id, :flag_tracker=>false, :category=>"Task", :project_id=>@req.project_id)

          end
        end
      end
    end
    respond_to do |format|
      format.js
    end

  end

  #Delete linked a tracker
  def destroy_tracker_req
    find_user
    if !@user.nil?
      if (!@tracker.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@tracker.user_id) or (!current_member.nil? and @user.id==@tracker.member_id)))
        @tracker.destroy
      else
        flash[:notice]=t(:tracker_no_user)
      end
      if !session[:req_id].nil?
        redirect_to show_trackers_url(:req=>session[:req_id])
      else
        redirect_to requirements_path
      end
    else
      redirect_to sign_in_url
    end
  end

  #To mark a linked tracker with requirement as complete or incomplete
  def tracker_flag_req
    find_user
    if !@user.nil?
      @tracker=Tracker.find_by_id(params[:id])
      if params[:tracker_flag]=="checked" and !@tracker.nil?
        @tracker.update_attributes(:flag_tracker=>true)
      elsif !@tracker.nil?
        @tracker.update_attributes(:flag_tracker=>false)
      end

      @all_user=Tracker.find_all_user(@user)
      if !session[:req_id].nil?
        req=Requirement.find(session[:req_id])
        @tracker_reqs=Tracker.find_tracker_by_req(req)
      end
    end
    respond_to do |format|
      format.js

    end
  end

  #Edit a linked tracker
  def edit_tracker_req
    find_user
    if !@user.nil?
      tracker_assigned=@tracker.assigned
      if !@tracker.nil?
        date1=params[:due1].split('/')
        if !date1[1].nil?
          @tracker.update_attributes(:category=>params[:category][0], :due=>Date.strptime("{ #{date1[2]}, #{date1[0]}, #{date1[1]} }", "{ %Y, %m, %d }"), :assigned=>params[:assigned][:id], :assigned_subscriber_id=>@subscriber_id, :title=>params[:title])
        else
          @tracker.update_attributes(:category=>params[:category][0], :assigned=>params[:assigned][:id], :assigned_subscriber_id=>@subscriber_id, :title=>params[:title])
        end
        if (!params[:assigned][:id].empty?)
          if (tracker_assigned!=params[:assigned][:id])
            address=Address.find_by_first_name(params[:assigned][:id])
            if !address.nil?
              user=User.find(address.user_id)
              if !user.nil?
                first_name=address.first_name
                @notification=Notification.find(:all, :conditions=>["user_id=? and project_id=?", user.id, @tracker.project_id])
              end
            end

            if user.nil? and address.nil?
              user=Member.find_by_first_name((params[:assigned][:id]))
              if !user.nil?
                first_name=user.first_name
                @notification=Notification.find(:all, :conditions=>["member_id=? and project_id=?", user.id, @tracker.project_id])
              end
            end
            if  !@notification.nil?
              if !@notification.empty? and @notification[0].task_assigned==true
                UserMailer.notification_task_assigned(user, @tracker, first_name).deliver
              end
            end
          end
        end

        if !current_user.nil?
          Tracker.notification_task_modified(current_user.id, @tracker.project_id, @tracker)
        elsif !current_member.nil?
          Tracker.notification_task_modified(@user.user_id, @tracker.project_id, @tracker)
        end

      end
      if !session[:req_id].nil?
        redirect_to show_trackers_url(:req=>session[:req_id])
      else
        redirect_to requirements_path
      end
    else
      redirect_to sign_in_url
    end
  end

  #Link a tracker with use case
  def create_tracker_use
    find_user
    if !@user.nil?
      if !session[:use_case_id].nil?
        @use=UseCase.find_by_id(session[:use_case_id])
        if !params[:tracker_name].empty?
          if !current_user.nil? and !@use.nil?
            @tracker_use=@use.trackers.create(:title=>params[:tracker_name], :user_id=>@user.id, :flag_tracker=>false, :category=>"Task", :project_id=>@use.project_id)
          else
            !current_member.nil?  and !@use.nil?
            @tracker_use=@use.trackers.create(:title=>params[:tracker_name], :user_id=>@user.user_id, :member_id=>@user.id, :flag_tracker=>false, :category=>"Task", :project_id=>@use.project_id)
          end
        end
      end
    end
    respond_to do |format|
      format.js
    end
  end

  #To mark a linked tracker with use case as complete or incomplete
  def tracker_flag_usecase
    find_user
    if !@user.nil?
      @tracker=Tracker.find_by_id(params[:id])
      if params[:tracker_flag]=="checked" and !@tracker.nil?
        @tracker.update_attributes(:flag_tracker=>true)
      elsif !@tracker.nil?
        @tracker.update_attributes(:flag_tracker=>false)
      end
      @all_user=Tracker.find_all_user(@user)
      if !session[:use_case_id].nil?
        use=UseCase.find(session[:use_case_id])
        @tracker_usecases=Tracker.find_tracker_by_req(use)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  #Delete linking of a tracker with use case
  def destroy_tracker_use
    find_user
    if !@user.nil?
      if (!@tracker.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@tracker.user_id) or (!current_member.nil? and @user.id==@tracker.member_id)))
        @tracker.destroy
      else
        flash[:notice]=t(:tracker_no_user)
      end

      respond_to do |format|
        if !session[:use_case_id].nil?
          format.html { redirect_to :controller=>"use_cases", :action=>"show_tracker_use", :use=>session[:use_case_id] }
        else
          redirect_to use_cases_path
        end
      end
    else
      redirect_to sign_in_url
    end
  end

  #Edit a tracker that is linked with use case
  def edit_tracker_use
    find_user
    if !@user.nil?
      tracker_assigned=@tracker.assigned
      if !@tracker.nil?
        date1=params[:due1].split('/')
        if !date1[1].nil?
          @tracker.update_attributes(:category=>params[:category][0], :due=>Date.strptime("{ #{date1[2]}, #{date1[0]}, #{date1[1]} }", "{ %Y, %m, %d }"), :assigned=>params[:assigned][:id], :assigned_subscriber_id=>@subscriber_id, :title=>params[:title])
        else
          @tracker.update_attributes(:category=>params[:category][0], :assigned=>params[:assigned][:id], :assigned_subscriber_id=>@subscriber_id, :title=>params[:title])
        end
        if (!params[:assigned][:id].empty?)
          if (tracker_assigned!=params[:assigned][:id])
            address=Address.find_by_first_name(params[:assigned][:id])
            if !address.nil?
              user=User.find(address.user_id)
              if !user.nil?
                first_name=address.first_name
                @notification=Notification.find(:all, :conditions=>["user_id=? and project_id=?", user.id, @tracker.project_id])
              end
            end

            if user.nil? and address.nil?
              user=Member.find_by_first_name((params[:assigned][:id]))
              if !user.nil?
                first_name=user.first_name
                @notification=Notification.find(:all, :conditions=>["member_id=? and project_id=?", user.id, @tracker.project_id])
              end
            end
            if  !@notification.nil?
              if !@notification.empty? and @notification[0].task_assigned==true
                UserMailer.notification_task_assigned(user, @tracker, first_name).deliver
              end
            end
          end
        end

        if !current_user.nil?
          Tracker.notification_task_modified(current_user.id, @tracker.project_id, @tracker)
        else
          !current_member.nil?
          Tracker.notification_task_modified(@user.user_id, @tracker.project_id, @tracker)
        end
      end
      if !session[:use_case_id].nil?
        redirect_to show_trackers_use_url(:use=>session[:use_case_id])
      else
        redirect_to use_cases_path
      end
    else
      redirect_to sign_in_url
    end
  end
  #To show all linked trackers with a requirement
  def show_req
    find_user
    if !@user.nil?
      @tracker_reqs=@tracker.requirements.find :all
      session[:tracker_id]=@tracker.id
      @attr=Attribute.find_by_project_id(session[:project_id])
      respond_to do |format|
        format.html { render "requirements/index" }
      end
    else
      redirect_to sign_in_url
    end

  end

#show use cases that are linked  to tracker
  def show_use_case
    find_user
    if !@user.nil?
      @tracker_use_cases=@tracker.use_cases.find(:all, :order => "updated_at desc")
      session[:tracker_id]=@tracker.id
      respond_to do |format|
        assign_project
        @attr=Attribute.find_by_project_id(session[:project_id])
        format.html { render "use_cases/index" }
      end
    else
      redirect_to sign_in_url
    end
  end

  #To create a comment
  def create_comment
    find_user
    if !@user.nil?
      @tracker=Tracker.find_by_id(params[:id])
      if !current_user.nil?  and !@tracker.nil?
        @comment=@tracker.comments.create(:title=>params[:comment], :user_id=>@user.id)
      elsif !current_member.nil?  and !@tracker.nil?
        @comment=@tracker.comments.create(:title=>params[:comment], :user_id=>@user.user_id, :member_id=>@user.id)
      end
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

  #To update comments
  def update_tracker_comment
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
    redirect_to trackers_path
  end

  #To sort all trackers
  def sort_tracker
    find_user
    if !@user.nil?
      assign_project
      if params[:name]=="created_at"
        @trackers=Tracker.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]} desc")
      else
        @trackers=Tracker.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]}")
      end
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
      @all_user=Tracker.find_all_user(@user)
      @subscriber_id=@user.id
      session[:admin_id]=@user.id
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      @all_user=Tracker.find_all_user1(@user)
      @subscriber_id=@user.user_id
      session[:admin_id]=@user.user_id
    end
  end

  #To check tracker exists or not
  def load_object
    unless @tracker = Tracker.find_by_id(params[:id])
      redirect_to trackers_path
    end
  end

end
