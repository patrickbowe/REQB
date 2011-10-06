class HomesController < ApplicationController
  
  def index
    @project=Project.new
    if session[:project_id].nil? and !current_user.nil?
      project=Project.assign_project_id(current_user.id)
      if !project.empty?
        session[:project_id]=project[0].id
      end
    elsif session[:project_id].nil? and !current_member.nil?
      project=Project.assign_project_id(session[:admin_id])
      if !project.empty?
        session[:project_id]=project[0].id
      end
    end

    respond_to do |format|
      format.html{render "index"}
    end
  end

  def account_details
    
  end

  def dashboard
    @project=Project.new
        if session[:project_id].nil? and !current_user.nil?
          project=Project.assign_project_id(current_user.id)
          if !project.empty?
            session[:project_id]=project[0].id
          end
        elsif session[:project_id].nil? and !current_member.nil?
          project=Project.assign_project_id(session[:admin_id])
          if !project.empty?
            session[:project_id]=project[0].id
          end
        end
   
  end
  
  def search_text

   if !params[:search_text].eql?("Type Your Text") or !params[:search_text].eql?("")
    @reqs=Requirement.find(:all,:conditions=>["name=? or status=? or category=? or type1=?",params[:search_text],params[:search_text],params[:search_text],params[:search_text]])
    @uses=UseCase.find(:all,:conditions=>["name=? or status=? or category=?",params[:search_text],params[:search_text],params[:search_text]])
    @trackers=Tracker.find(:all,:conditions=>["title=? or category=?",params[:search_text],params[:search_text]])
    @files=ProjectFile.find(:all,:conditions=>["file_file_name=? or description=? or type1=?",params[:search_text],params[:search_text],params[:search_text]])
    @defs=Definition.find(:all,:conditions=>["term=? or definition=?",params[:search_text],params[:search_text]])
  end
    find_user
  


  end

  def get_help
    @helps=Help.find :all,:order=>"id desc",:limit=>10
    find_user
  end

  def search_help
    @helps=Help.find(:all,:conditions=>["faq like?","%#{params[:search_text]}%"])
  end

  def new
    find_user
    @help_request=@user.help_requests.build
  end

  def create
    find_user
    @help_request=@user.help_requests.build(params[:help_request])
    if @help_request.save
      UserMailer.send_help_request(@help_request)
      redirect_to get_help_url
    else
      render :new
    end
  end

private


      def find_user
        if !current_user.nil?
          @user=User.find(current_user.id)
        else
          @user=Member.find(current_member.id)
        end
      end

end
