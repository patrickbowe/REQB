class DefinitionsController < ApplicationController
  before_filter :store_location, :only => [:show]
  before_filter :load_object, :only => [:destroy_def, :edit_def, :show]

  #To show all definitions
  def index
    find_user
    if !@user.nil?
      assign_project_use
      @defs=Definition.find(:all, :conditions=>["project_id=?", session[:project_id]], :order=>"term")
      #@defs=@defs.sort! { | a, b | a.term <=> b.term }
    else
      redirect_to sign_in_url
    end

  end

  #To show a definition
  def show
    respond_to do |format|
      if current_user.nil? and current_member.nil?
        session[:project_id]=@def.project_id
        format.html { redirect_to sign_in_url }
      else
        find_user
        assign_project_use
        format.html { render "show" }
      end
    end
  end

  #To create definition
  def create_term
    find_user
    if !@user.nil?
      assign_project_use
      @project=Project.find(session[:project_id])
      def1=params[:def]
      if !@project.nil? and !current_user.nil?
        if !params[:term].empty? and !def1.eql?("<< Add definition")
          @term=@project.definitions.create(:term=>params[:term], :user_id=>@user.id, :definition=>params[:def])
        elsif  !params[:term].empty? and def1.eql?("<< Add definition")
          @term=@project.definitions.create(:term=>params[:term], :user_id=>@user.id)
        end
        if !@term.id.nil?
          Definition.notification_create(current_user.id, @project.id, @term)
        end
      else
        if !@project.nil? and !current_member.nil?
          if !params[:term].empty? and !def1.eql?("<< Add definition")
            @term=@project.definitions.create(:term=>params[:term], :member_id=>@user.id, :user_id=>@user.user_id, :definition=>params[:def])
          elsif !params[:term].empty? and def1.eql?("<< Add definition")
            @term=@project.definitions.create(:term=>params[:term], :member_id=>@user.id, :user_id=>@user.user_id)
          end
          if !@term.id.nil?
            Definition.notification_create(@user.user_id, @project.id, @term)
          end
        end

      end
      respond_to do |format|
        @defs=@project.definitions.find(:all, :order=>"term")
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end


  #To destroy a definition
  def destroy_def
    find_user
    if !@user.nil?
      if (!@def.nil? and (@user.privilige=="Admin" or (!current_user.nil? and @user.id==@def.user_id) or (!current_member.nil? and @user.id==@def.member_id)))
        @def.destroy
      else
        flash[:notice]=t(:def_no_user)
      end
      redirect_to definitions_path
    else
      redirect_to sign_in_url
    end
  end

  #To edit a definition
  def edit_def

    id=params[:id]
    @def.update_attributes(:term=>params[:"term_#{id}"], :definition=>params[:"definition_#{id}"])
    redirect_to definitions_path
  end

  #To sort definitions
  def sort_def
    find_user
    if !@user.nil?
      assign_project_use
      if params[:name]=="created_at"
        @defs=Definition.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]} desc")
      else
        @defs=Definition.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "#{params[:name]}")
      end
    end

  end

  #To search a definition
  def search_def
    find_user
    if !@user.nil?
      assign_project_use
      @defs=Definition.find(:all, :conditions=>["project_id=? and term ILIKE ?", session[:project_id], "#{params[:name]}%"])
    end

  end

  private
  #To check user is either subsecriber or member
  def find_user
    if !current_user.nil?
      @user=User.find(current_user.id)
      session[:admin_id]=@user.id
    else
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
    end
  end

  #To check definition exists or not
  def load_object
    unless @def = Definition.find_by_id(params[:id])
      redirect_to definitions_path
    end
  end

end
