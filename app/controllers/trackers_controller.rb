class TrackersController < ApplicationController

 def index
      assign_project
      find_user
      @all_user=Tracker.find_all_user
      @trackers=Tracker.find_tracker(session[:project_id])
  end

 def create
     assign_project
     find_user
     @all_user=Tracker.find_all_user
     if !params[:tracker_name].empty?
       @project=Project.find(session[:project_id])
       if !current_user.nil?
          @tracker=@project.trackers.create(:title=>params[:tracker_name],:user_id=>@user.id,:flag_tracker=>false,:category=>"Configuration")
       else
          @tracker=@project.trackers.create(:title=>params[:tracker_name],:user_id=>@user.user_id,:member_id=>@user.id,:flag_tracker=>false,:category=>"Configuration")
       end
       @tracker.save
       respond_to do |format|
          format.js

     end
     end
   end

   def edit
     @all_user=Tracker.find_all_user
     @tracker=Tracker.find(params[:id])
       if @tracker.update_attributes(:category=>params[:category][0],:due=>params[:due1],:assigned=>params[:assigned][:id],:title=>params[:title])
         redirect_to trackers_path
       else
         redirect_to :back
       end
   end

   def destroy
     find_user
     @tracker=Tracker.find(params[:id])
     if !@tracker.nil?
        @tracker.destroy
     end
     @all_user=Tracker.find_all_user
     redirect_to trackers_path
  end

 def show
     @tracker=Tracker.find(params[:id])
      @all_user=Tracker.find_all_user
     find_user
     assign_project
   end

  def tracker_flag
    @tracker=Tracker.find(params[:id])
    if params[:tracker_flag]=="checked"
       @tracker.update_attributes(:flag_tracker=>true)
    else
       @tracker.update_attributes(:flag_tracker=>false)
    end
    @trackers=Tracker.find_tracker(session[:project_id])
    respond_to do |format|
          format.js

     end
  end

 def match_tracker_name

       tracker1=params[:char]
       @tracker=Tracker.find(:all,:conditions=>["title LIKE ? and project_id=?","#{tracker1}%",session[:project_id]])
        respond_to do |format|
         format.js { render :json=> @tracker }
       end
     end
  #Link a tracker to requirement
  def create_tracker_req
      @tracker_req1=Tracker.find(:all,:conditions=>["title LIKE ?",params[:tracker_name]])
        if !@tracker_req1.nil?
          if !@tracker_req1.empty?
              @req=Requirement.find(session[:req_id])
              flag=Tracker.find_link_req_tracker(@req,@tracker_req1[0])
              if flag==false
               Tracker.insert_req_tracker(@req,@tracker_req1[0])
               @tracker_req=@tracker_req1[0]
              end
          end
        end
       @all_user=Tracker.find_all_user
       @user=find_user
       respond_to do |format|
          format.js
       end
     
   end
 #Delete linked a tracker
 def destroy_tracker_req
   find_user
   req=Requirement.find(session[:req_id])
   @tracker=Tracker.find(params[:id])
   if !@tracker.nil?
         @tracker.requirements.delete(req)
   end
          @all_user=Tracker.find_all_user
          redirect_to show_trackers_url(:req=>session[:req_id])
   
 end
 #Edit a linked tracker
 def edit_tracker_req
     @requirement=Requirement.find(session[:req_id])
     @tracker=Tracker.find(params[:id])
        if !@tracker.nil?
         @tracker.update_attributes(:category=>params[:category][0],:due=>params[:due1],:assigned=>params[:assigned][:id],:title=>params[:title])
        end
     @all_user=Tracker.find_all_user
     redirect_to show_trackers_url(:req=>session[:req_id])
 end

 #Link a tracker with use case 
 def create_tracker_use
   @tracker_use1=Tracker.find(:all,:conditions=>["title LIKE ?",params[:tracker_name]])
   if !@tracker_use1.nil?
      if !@tracker_use1.empty?
        @use=UseCase.find(session[:use_case_id])
        flag=Tracker.find_link_use_tracker(@use,@tracker_use1[0])
        if flag==false
           Tracker.insert_use_tracker(@use,@tracker_use1[0])
            @tracker_use=@tracker_use1[0]
        end
     end
  end
  @user=find_user
  @all_user=Tracker.find_all_user
  respond_to do |format|
           format.js
  end
 end

 #Delete linking of a tracker with use case
  def destroy_tracker_use
    find_user
    use=UseCase.find(session[:use_case_id])
    @tracker=Tracker.find(params[:id])
    if !@tracker.nil?
         @tracker.use_cases.delete(use)
    end
    @all_user=Tracker.find_all_user
    respond_to do |format|
       format.html {redirect_to :controller=>"use_cases",:action=>"show_tracker_use",:use=>session[:use_case_id]}
    end
 end

 #Edit a tracker that is linked with use case
  def edit_tracker_use
     
     @tracker=Tracker.find(params[:id])
     if !@tracker.nil?
        @tracker.update_attributes(:category=>params[:category][0],:due=>params[:due1],:assigned=>params[:assigned][:id],:title=>params[:title])
     end
     @all_user=Tracker.find_all_user
     redirect_to show_trackers_use_url(:use=>session[:use_case_id])
  end
 
 def create_comment
     @tracker=Tracker.find(params[:id])
     find_user
     if !current_user.nil?
       @comment=@tracker.comments.create(:title=>params[:comment],:user_id=>@user.id)
     else
       @comment=@tracker.comments.create(:title=>params[:comment],:user_id=>@user.user_id,:member_id=>@user.id)
     end

     respond_to do |format|
       format.js
     end
 end

 def delete_comment
  @comment=Comment.find(params[:id])
  if !@comment.nil?
     @comment.destroy
  end
    redirect_to trackers_path
end

 def sort_tracker
    assign_project
    find_user
    @all_user=Tracker.find_all_user
    @trackers=Tracker.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "#{params[:name]}")   
 end
private
        def assign_project
                 if !session[:project_id].nil?
                          find_project=Project.find_by_id(session[:project_id])
                          if find_project.nil?
                            project=Project.assign_project_id(session[:admin_id])
                            if !project.empty?
                               session[:project_id]=project[0].id
                            end
                          end
                       end
              end

             def find_user
               if !current_user.nil?
                 @user=User.find(current_user.id)
               else
                 @user=Member.find(current_member.id)
               end
             end
          
end
