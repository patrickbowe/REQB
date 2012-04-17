class RequirementsController < ApplicationController
  before_filter :store_location, :only => [:show]
  before_filter :load_object, :only => [:destroy, :edit, :show, :edit_requirement_use,:edit_requirement_tracker,:edit_requirement_file]

  #To show all requirements corresponding to user
  def index
    find_user
    if !@user.nil?
      assign_project
      @requirements=Requirement.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "created_at desc")
      @attr=Attribute.find_by_project_id(session[:project_id])
    else
      redirect_to sign_in_url
    end

  end

  #To create a requirement
  def create
    find_user
    if !@user.nil?
      assign_project
      if !params[:req_name].empty? and @user.privilige!="Read"
        @project=Project.find(session[:project_id])
        if !current_user.nil?
          @project_req=@project.requirements.create(:type1=>"Functional", :name=>params[:req_name], :category=>"Uncategorised", :status=>"Draft", :user_id=>@user.id, :priority=>"Medium", :importance=>"Interesting")
          if !@project_req.id.nil?
            first_name=@project_req.find_user_first_name(current_user.id)
            Requirement.notification_create(current_user.id, @project.id, @project_req, first_name)
          end
        elsif !current_member.nil?

          @project_req=@project.requirements.create(:type1=>"Functional", :name=>params[:req_name], :category=>"Uncategorised", :status=>"Draft", :user_id=>@user.user_id, :member_id=>@user.id, :priority=>"Medium", :importance=>"Interesting")
          if !@project_req.id.nil?
            first_name=@project_req.find_member_first_name(@user.id)
            Requirement.notification_create(@user.user_id, @project.id, @project_req, first_name)
          end
        end

        @attr=Attribute.find_by_project_id(session[:project_id])

      end
      respond_to do |format|
        format.js
      end
    end
  end

  #To edit a requirement
  def edit

    status=@req.status
    find_user
    if !@user.nil?
      if ((status!="Approved" and params[:requirement][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Approve" or @user.privilige=="Read/Write/Approve")) or (status!="Approved" and params[:requirement][:status]!="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Approve")) or (status=="Approved" and @user.privilige=="Admin")or (status=="Approved" and params[:requirement][:status]=="Approved" and !params[:requirement][:delivered].empty? and @user.privilige!="Read"))
        if @req.update_attributes(params[:requirement])
          if (!params[:requirement][:status].nil?)
            if (status!="Approved" and params[:requirement][:status]=="Approved")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status!="For Review" and params[:requirement][:status]=="For Review")
              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_reviewed(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_reviewed(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status=="Approved" and params[:requirement][:status]!="Approved")
              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_no_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_no_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            end
          end
          redirect_to requirements_path
        else
          redirect_to :back
        end
      else

        flash[:notice]= t(:requirement_no_approve)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #To show a requirement
  def show

    respond_to do |format|
      if current_user.nil? and current_member.nil?
        session[:project_id]=@req.project_id
        format.html { redirect_to sign_in_url }
      else
        find_user
        @attr=Attribute.find_by_project_id(session[:project_id])
        format.html { render "show" }
      end
    end


  end

  #To delete a requirement
  def destroy
    find_user
    if !@user.nil?
      use_cases=@req.use_cases.find :all
      if @user.privilige=="Admin" and @req.status!="Approved"
        if @req.destroy
          delete_usecase(use_cases)
          flash[:notice]="Req#{params[:id]} was successfully deleted"
          redirect_to requirements_path
        else
          redirect_to :back
        end
      elsif !current_user.nil? and @user.id==@req.user_id and @req.status!="Approved" and (@user.privilige!="Read")
        if @req.destroy
          delete_usecase(use_cases)
          flash[:notice]="Req#{params[:id]} was successfully deleted"
          redirect_to requirements_path
        else
          redirect_to :back
        end
      elsif !current_member.nil? and @user.id==@req.member_id and @req.status!="Approved" and (@user.privilige!="Read")
        if @req.destroy
          delete_usecase(use_cases)
          flash[:notice]="Req#{params[:id]} was successfully deleted"
          redirect_to requirements_path
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

  #create maximum 10 requirements
  def create_requirements
    name=params[:name]
    status=params[:status]
    category=params[:category]
    type1=params[:type1]
    find_user
    if !@user.nil?
      assign_project
      @project=Project.find(session[:project_id])
      for i in 1..10 do
        if !name[i.to_s].empty?
          if !current_user.nil?
            if !category.nil?
              @project_req=@project.requirements.create(:type1=>type1[i.to_s][0], :name=>name[i.to_s], :category=>category[i.to_s][0], :status=>status[i.to_s][0], :user_id=>@user.id, :priority=>"Medium", :importance=>"Interesting")
            else
              @project_req=@project.requirements.create(:type1=>type1[i.to_s][0], :name=>name[i.to_s], :category=>"Uncategorised", :status=>status[i.to_s][0], :user_id=>@user.id, :priority=>"Medium", :importance=>"Interesting")
            end
            if !@project_req.id.nil?
              first_name=@project_req.find_user_first_name(current_user.id)
              Requirement.notification_create(current_user.id, @project.id, @project_req, first_name)
              if status[i.to_s][0]=="Approved"
                first_name=@project_req.find_user_first_name(current_user.id)
                Requirement.notification_approved(current_user.id, @project.id, @project_req, first_name)
              elsif status[i.to_s][0]=="Reviewed"
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_reviewed(current_user.id, @project.id, @project_req, first_name)
              end
            end
          else
            if !category.nil?
              @project_req=@project.requirements.create(:type1=>type1[i.to_s][0], :name=>name[i.to_s], :category=>category[i.to_s][0], :status=>status[i.to_s][0], :user_id=>@user.user_id, :member_id=>@user.id)
            else
              @project_req=@project.requirements.create(:type1=>type1[i.to_s][0], :name=>name[i.to_s], :category=>"Uncategorised", :status=>status[i.to_s][0], :user_id=>@user.user_id, :member_id=>@user.id)
            end
            if !@project_req.id.nil?
              first_name=@project_req.find_member_first_name(@user.id)
              Requirement.notification_create(@user.user_id, @project.id, @project_req, first_name)
              if status[i.to_s][0]=="Approved"
                first_name=@project_req.find_member_first_name(@user.id)
                Requirement.notification_approved(@user.user_id, @project.id, @project_req, first_name)
              elsif status[i.to_s][0]=="Reviewed"
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_reviewed(@user.user_id, @project.id, @project_req, first_name)
              end
            end
          end

        end
      end
      redirect_to requirements_path

    else
      redirect_to sign_in_url
    end
  end

  #show use cases that are linked  to requirement
  def show_use_case
    find_user
    if !@user.nil?
      assign_project
      @req=Requirement.find_by_id(params[:req])
      if !@req.nil?
        @req_use_cases=@req.use_cases.find(:all, :order => "updated_at desc")
        session[:req_id]=@req.id
        respond_to do |format|
          @attr=Attribute.find_by_project_id(session[:project_id])
          format.html { render "use_cases/index" }
        end
      else
        redirect_to requirments_path
      end

    else
      redirect_to sign_in_url
    end

  end

  #match requirement name 
  def match_requirement_name
    find_user
    if !@user.nil?
      assign_project
      @requirement=Requirement.find(:all, :conditions=>["name ILIKE ? and project_id=?", "#{params[:char]}%", session[:project_id]])
      respond_to do |format|
        format.js { render :json=> @requirement }
      end
    else
      respond_to do |format|
        format.js
      end
    end

  end

  #Linked a requirement with  given an usecase 
  def create_requirement_use
    find_user
    if !@user.nil?
      assign_project
      @requirement1=Requirement.find(:all, :conditions=>["name ILIKE ? and project_id=?", params[:requirement], session[:project_id]])
      if !@requirement1.empty? and @user.privilige!="Read"
        if !session[:use_case_id].nil?
          @use=UseCase.find(session[:use_case_id])
          flag=Requirement.find_link_req_use(@use, @requirement1[0])
          if flag==false
            Requirement.insert_req_use(@use, @requirement1[0])
            @usecase_req=@requirement1[0]
          end
        end
      end
      @attr=Attribute.find_by_project_id(session[:project_id])
    end

    respond_to do |format|

      format.js
    end

  end

  #Unlinked a requirement from a given use_case
  def destroy_requirement_use
    @user=find_user
    if !@user.nil?
      @use_req=Requirement.find_by_id(params[:id])
      if !session[:use_case_id].nil?
        @use_case=UseCase.find(session[:use_case_id])
        if !@use_case.nil? and @user.privilige!="Read" and !@use_req.nil?
          @use_req.use_cases.delete(@use_case)
        end
        respond_to do |format|
          assign_project
          @attr=Attribute.find_by_project_id(session[:project_id])
          if !@use_case.nil?
            format.html { redirect_to show_requirements_url(@use_case.id) }
          else
            format.html { redirect_to use_cases_url }
          end
        end
      else
        redirect_to use_cases_path
      end
    else
      redirect_to sign_in_url
    end
  end

  #Edit linked a requirement
  def edit_requirement_use
    find_user
    if !@user.nil?
      status=@req.status
      if ((status!="Approved" and params[:requirement][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Approve" or @user.privilige=="Read/Write/Approve")) or (status!="Approved" and params[:requirement][:status]!="Approved" and (@user.privilige!="Read")) or (status=="Approved" and @user.privilige=="Admin")or (status=="Approved" and params[:requirement][:status]=="Approved" and !params[:requirement][:delivered].empty? and @user.privilige!="Read"))
        if @req.update_attributes(params[:requirement])
          if (!params[:requirement][:status].nil?)

            if (status!="For Review" and params[:requirement][:status]=="For Review")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_user_first_name(current_member.id)
                Requirement.notification_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status!="Reviewed" and params[:requirement][:status]=="Reviewed")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_reviewed(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_reviewed(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status=="Approved" and params[:requirement][:status]!="Approved")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_no_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_no_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            end
          end

        end
        assign_project
        @attr=Attribute.find_by_project_id(session[:project_id])
        if !session[:use_case_id].nil?
          redirect_to show_requirements_url(@use_case.id)
        else
          redirect_to use_cases_path
        end

      else


        flash[:notice]= t(:requirement_edit_message_with_out_permisson)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #To show all linked requirement corresponding to a tracker
  def show_tracker
    find_user
    if !@user.nil?
      assign_project
      @req = Requirement.find_by_id(params[:req])
      if !@req.nil?
         @all_user=Tracker.find_all_user(@user)
         @tracker_reqs=Tracker.find_tracker_by_req(@req)
         #@tracker_reqs=req.trackers.find(:all,:order => "updated_at desc")
         session[:req_id]=@req.id
         respond_to do |format|
           format.html { render "trackers/index" }
      end
    else
      redirect_to sign_in_url
    end

    end
 end   

#Linked a requirement with  given an tracker
  def create_requirement_tracker
    find_user
    if !@user.nil?
      assign_project
      @requirement1=Requirement.find(:all, :conditions=>["name ILIKE ? and project_id=?", params[:requirement], session[:project_id]])
      if !@requirement1.empty? and @user.privilige!="Read"
        if !session[:tracker_id].nil?
          @tracker=Tracker.find(session[:tracker_id])
          flag=Requirement.find_link_req_tracker(@tracker, @requirement1[0])
          if flag==false
            Requirement.insert_req_tracker(@tracker, @requirement1[0])
            @tracker_req=@requirement1[0]
          end
        end
      end
      @attr=Attribute.find_by_project_id(session[:project_id])

    end
    respond_to do |format|
      format.js
    end

  end

  #Unlinked a requirement from a given tracker
  def destroy_requirement_tracker
    @user=find_user
    if !@user.nil?
      @tracker_req=Requirement.find_by_id(params[:id])
      if !session[:tracker_id].nil?
        @tracker=Tracker.find(session[:tracker_id])
        if !@tracker.nil? and @user.privilige!="Read" and !@tracker_req.nil?
          @tracker_req.trackers.delete(@tracker)
          respond_to do |format|
            @attr=Attribute.find_by_project_id(session[:project_id])
            format.html { redirect_to show_tracker_req_url(@tracker.id) }

          end
        else

          redirect_to trackers_path
        end
      else
        redirect_to trackers_path
      end
    else
      respond_to do |format|
        format.html { redirect_to sign_in_url }
      end
    end

  end

  #Edit linked a requirement
  def edit_requirement_tracker
    find_user
    if !@user.nil?

      status=@req.status

      if ((status!="Approved" and params[:requirement][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Approve" or @user.privilige=="Read/Write/Approve")) or (status!="Approved" and params[:requirement][:status]!="Approved" and (@user.privilige!="Read")) or (status=="Approved" and @user.privilige=="Admin") or (status=="Approved" and params[:requirement][:status]=="Approved" and !params[:requirement][:delivered].empty? and @user.privilige!="Read"))
        if @req.update_attributes(params[:requirement])
          if (!params[:requirement][:status].nil?)

            if (status!="Approved" and params[:requirement][:status]=="Approved")

              if !current_user.nil?
                first_name=@project_req.find_user_first_name(current_user.id)
                Requirement.notification_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@project_req.find_member_first_name(@user.id)
                Requirement.notification_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status!="For Review" and params[:requirement][:status]=="For Review")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_reviewed(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_reviewed(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status=="Approved" and params[:requirement][:status]!="Approved")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_no_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_no_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            end
          end

        end
        @attr=Attribute.find_by_project_id(session[:project_id])
        if !session[:tracker_id].nil?
          @tracker=Tracker.find(session[:tracker_id])
          redirect_to show_tracker_req_url(@tracker.id)
        else
          redirect_to trackers_path
        end

      else


        flash[:notice]= t(:requirement_edit_message_with_out_permisson)
        redirect_to :back
      end
    else
      redirect_to sign_in_url
    end
  end

  #create and delete comments that are related to requirement
  def create_comment
    find_user
    if !@user.nil?
      @req=Requirement.find(params[:id])
      if !current_user.nil? and !@req.nil?
        @comment=@req.comments.create(:title=>params[:comment], :user_id=>@user.id)
      elsif  !current_member.nil? and !@req.nil?
        @comment=@req.comments.create(:title=>params[:comment], :user_id=>@user.user_id, :member_id=>@user.id)
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

  #To delete all comments
  def delete_comment1
    params[:comment].each { |key, value|
      comment=Comment.find(key)
      if !comment.nil?
        k comment.destroy
      end
    }
    redirect_to requirements_path
  end

  #To update a comment
  def update_comment
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
    redirect_to requirements_path
  end

  #show files that are linked to a requirement
  def show_file
    @req = Requirement.find_by_id(params[:req])
    find_user
    if !@user.nil?
      assign_project

      if !current_user.nil?
        @flag=check_storage(@user.id)
      else
        @flag=check_storage(@user.user_id)
      end
      @file_reqs=@req.project_files.find :all
      @file_req1=ProjectFile.new
      session[:req_id]=@req.id
      respond_to do |format|
        format.html { render "project_files/index" }
      end
    else
      redirect_to sign_in_url
    end
  end

  #To sort requirements corresponding to either type or name or date entered
  def sort_requirement
    find_user
    if !@user.nil?
      assign_project

      if params[:name]=="created_at"
        @requirements=Requirement.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]} desc")
      else
        @requirements=Requirement.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]}")
      end
      @attr=Attribute.find_by_project_id(session[:project_id])
    end
  end

  #Linked a requirement with  given an file
  def create_requirement_file
    find_user
    if !@user.nil?
      if !params[:requirement].empty?
        @requirement1=Requirement.find(:all, :conditions=>["name LIKE ?", params[:requirement]])

        if !@requirement1.empty? and @user.privilige!="Read"
          if !session[:file_id].nil?
            @file=ProjectFile.find(session[:file_id])
            flag=Requirement.find_link_req_file(@file, @requirement1[0])
            if flag==false
              Requirement.insert_req_file(@file, @requirement1[0])
              @file_req=@requirement1[0]
            end
          end
        end

      end
      assign_project
      @attr=Attribute.find_by_project_id(session[:project_id])
    end
    respond_to do |format|
      format.js
    end

  end

  #Unlinked a requirement with a given file
  def destroy_requirement_file
    @user=find_user
    if !@user.nil?
      @file_req=Requirement.find_by_id(params[:id])
      if !session[:file_id].nil?
        @file=ProjectFile.find(session[:file_id])
        if !@file.nil? and @user.privilige!="Read" and !@file_req.nil?
          @file_req.project_files.delete(@file)

          respond_to do |format|
            format.html { redirect_to show_file_reqs_url(@file.id) }
          end
        else
          redirect_to project_files_path
        end
      else
        redirect_to project_files_path
      end
    else
      respond_to do |format|
        format.html { redirect_to sign_in_url }
      end
    end
  end

  #Edit linked a requirement
  def edit_requirement_file
    find_user
    if !@user.nil?
      status=@req.status
      assign_project
      if ((status!="Approved" and params[:requirement][:status]=="Approved" and (@user.privilige=="Admin" or @user.privilige=="Approve" or @user.privilige=="Read/Write/Approve")) or (status!="Approved" and params[:requirement][:status]!="Approved" and (@user.privilige=="Admin" or @user.privilige=="Read/Write" or @user.privilige=="Read/Write/Approve" or @user.privilige=="Approve")) or (status=="Approved" and @user.privilige=="Admin")or (status=="Approved" and params[:requirement][:status]=="Approved" and !params[:requirement][:delivered].empty? and @user.privilige!="Read"))
        if @req.update_attributes(params[:requirement])
          if (!params[:requirement][:status].nil?)

            if (status!="Approved" and params[:requirement][:status]=="Approved")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status!="For Review" and params[:requirement][:status]=="For Review")

              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_reviewed(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_reviewed(@user.user_id, @req.project_id, @req, first_name)
              end
            elsif (status=="Approved" and params[:requirement][:status]!="Approved")
              find_user
              if !current_user.nil?
                first_name=@req.find_user_first_name(current_user.id)
                Requirement.notification_no_approved(current_user.id, @req.project_id, @req, first_name)
              else
                first_name=@req.find_member_first_name(@user.id)
                Requirement.notification_no_approved(@user.user_id, @req.project_id, @req, first_name)
              end
            end
          end

        end
        @attr=Attribute.find_by_project_id(session[:project_id])
        if !session[:file_id].nil?
          @file=ProjectFile.find(session[:file_id])
          redirect_to show_file_reqs_url(@file.id)
        else
          redirect_to project_files_path
        end

      else


        flash[:notice]= t(:requirement_edit_message_with_out_permisson)
        redirect_to :back
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

  #To check user is either subsecriber or member
  def find_user
    if !current_user.nil?
      @user=User.find(current_user.id)
      session[:admin_id]=@user.id
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      session[:admin_id]=@user.user_id
    end
  end

  #To delete usecases
  def delete_usecase(use_cases)

    if !use_cases.nil?
      use_cases.each do |use_case|
        use=UseCase.find(use_case.id)
        if !use.nil?
          use.destroy
        end
      end
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

  #To check requirement exists or not
  def load_object
    unless @req = Requirement.find_by_id(params[:id])
      redirect_to requirements_path
    end
  end
end
