class HomesController < ApplicationController
  require 'prawn'

  #To show index page of site
  def index
    if session[:project_id].nil? and !current_user.nil?
      project=Project.assign_project_id(current_user.id)
      if !project.empty?
        session[:project_id]=project[0].id
      end
      redirect_to dashboard_url
    elsif session[:project_id].nil? and !current_member.nil?
      project=Project.assign_project_id(session[:admin_id])
      if !project.empty?
        session[:project_id]=project[0].id
      end
      redirect_to dashboard_url
    elsif !session[:project_id].nil? and !current_user.nil?
      redirect_to dashboard_url
    elsif !session[:project_id].nil? and !current_member.nil?
      redirect_to dashboard_url
    else
      respond_to do |format|
        format.html { render "index" }
      end
    end


  end


  #To show Price page
  def pricing_list

  end

  #To show account details tab under My Account
  def account_details
    find_user
    if @user.nil?
      redirect_to sign_in_url
    end
  end

  #To show dismiss dashbaord when user does not have any activity
  def dismiss_dashboard

  end

  #To set dismiss dashboard flag
  def set_dismiss_dashboard_flag
    if !current_user.nil?
      user=User.find(current_user.id)
      user.update_attributes(:dismiss_dashboard=>true)
    elsif !current_member.nil?
      member=Member.find(current_member.id)
      member.update_attributes(:dismiss_dashboard=>true)
    else
      redirect_to sign_in_url
    end
  end

  #To show dash board page with all activities
  def dashboard
    find_user
    if ((!current_user.nil? and current_user.dismiss_dashboard==false) or (!current_member.nil? and current_member.dismiss_dashboard==false))
      respond_to do |format|
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
        format.html { redirect_to dismiss_dashboard_url }
      end
    elsif ((!current_user.nil? and current_user.dismiss_dashboard==true) or (!current_member.nil? and current_member.dismiss_dashboard==true))
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

      find_first_name(@user)
      @assign_trackers=Tracker.find(:all, :conditions=>["assigned_subscriber_id=? and assigned ILIKE ? and project_id=? and flag_tracker!=? ", @subscriber_id, @name.first_name, session[:project_id], true], :order=>"due desc")
      @notification_msg=@user.notification_message.find(:all, :conditions=>["project_id=? and dismiss_flag!=?", session[:project_id], true])
      @due_trackers=Tracker.find(:all, :conditions=>["due=? and project_id=? and flag_tracker=?", Date.today.strftime("%Y-%m-%d"), session[:project_id], false], :order=>"due desc")
      @approve_req=Requirement.find(:all, :conditions=>["status=? and project_id=?", "For Review", session[:project_id]])
      @approve_use=UseCase.find(:all, :conditions=>["status=? and project_id=?", "For Review", session[:project_id]])
      @approve_req_total=Requirement.count(:conditions=>["status=? and project_id=?", "Approved", session[:project_id]])
      @review_req_total=Requirement.count(:conditions=>["status=? and project_id=?", "For Review", session[:project_id]])
      @draft_req_total=Requirement.count(:conditions=>["status=? and project_id=?", "Draft", session[:project_id]])
      @approve_use_total=UseCase.count(:conditions=>["status=? and project_id=?", "Approved", session[:project_id]])
      @review_use_total=UseCase.count(:conditions=>["status=? and project_id=?", "For Review", session[:project_id]])
      @draft_use_total=UseCase.count(:conditions=>["status=? and project_id=?", "Draft", session[:project_id]])
    else
      redirect_to sign_in_url
    end
  end


  def dismiss_notification
    @msg=NotificationMessage.find_by_id(params[:id])
    if !@msg.nil?
      @msg.update_attributes(:dismiss_flag => true)
    else
      redirect_to :back
    end
  end

  #To set complete due tracker flag on dashboard page
  def complete_due_tracker
    @tracker=Tracker.find_by_id(params[:id])
    if !@tracker.nil?
      @tracker.update_attributes(:flag_tracker => true)
    else
      redirect_to :back
    end
  end

  #To delete tracker on dashboard page
  def delete_tracker
    @tracker=Tracker.find_by_id(params[:id])
    if !@tracker.nil?
      @tracker.destroy
    else
      redirect_to :back
    end
  end

  #To set complete assigned tracker flag on dahsboard page
  def complete_assigned_tracker
    find_user
    if !@user.nil?
      @tracker=Tracker.find_by_id(params[:id])
      if @tracker.flag_tracker==true
        @tracker.update_attributes(:flag_tracker => false)
      else
        @tracker.update_attributes(:flag_tracker => true)
      end
      find_first_name(@user)
      @assign_trackers=Tracker.my_tracker(@subscriber_id, @name.first_name, session[:project_id])
    else
      redirect_to sign_in_url
    end
  end

  #To delete a tracker on dashboard page that is assigned to some one
  def delete_assigned_tracker
    @tracker=Tracker.find_by_id(params[:id])
    if !@tracker.nil?
      @tracker.destroy
    end
  end

  #To search text in whole site
  def search_text

    if !params[:search_text].eql?("Type Your Text") or !params[:search_text].eql?("")
      @reqs=Requirement.find(:all, :conditions=>["(name ILIKE ? or status ILIKE ? or category ILIKE ? or type1 ILIKE ?) and project_id=?", "%#{params[:search_text]}%", "%#{params[:search_text]}%", "%#{params[:search_text]}%", "%#{params[:search_text]}%", session[:project_id]])
      @uses=UseCase.find(:all, :conditions=>["(name ILIKE ? or status ILIKE ? or category ILIKE ?) and project_id=?", "%#{params[:search_text]}%", "%#{params[:search_text]}%", "%#{params[:search_text]}%", session[:project_id]])
      @trackers=Tracker.find(:all, :conditions=>["(title ILIKE ? or category ILIKE ?) and project_id=?", "%#{params[:search_text]}%", "%#{params[:search_text]}%", session[:project_id]])
      @files=ProjectFile.find(:all, :conditions=>["(file_file_name ILIKE ? or description ILIKE ? or type1 ILIKE ?) and project_id=?", "%#{params[:search_text]}%", "%#{params[:search_text]}%", "%#{params[:search_text]}%", session[:project_id]])
      @defs=Definition.find(:all, :conditions=>["(term ILIKE ? or definition ILIKE ? ) and project_id=?", "%#{params[:search_text]}%", "%#{params[:search_text]}%", session[:project_id]])
      @basic_flows=BasicFlow.find(:all, :conditions=>["(action ILIKE ? or response ILIKE ?) and project_id=? ", "%#{params[:search_text]}%", "%#{params[:search_text]}%", session[:project_id]], :joins=>"JOIN use_cases on use_cases.id=basic_flows.use_case_id")
      @alter_flows=AlternateFlow.find(:all, :conditions=>["title ILIKE ? and project_id=?", "%#{params[:search_text]}%", session[:project_id]], :joins=>"JOIN basic_flows on basic_flows.id=alternate_flows.basic_flow_id join use_cases on use_cases.id=basic_flows.use_case_id")
      @pre=PreCondition.find(:all, :conditions=>["title ILIKE ? and project_id=?", "%#{params[:search_text]}%", session[:project_id]], :joins=>"JOIN use_cases on use_cases.id=pre_conditions.use_case_id")
      @helps=Help.find(:all, :conditions=>["keywords ILIKE?", "%#{params[:search_text]}%"])
    end

    find_user
    if @user.nil?
      redirect_to sign_in_url
    end


  end

  #To show get help page
  def get_help
    @helps=Help.find :all
    find_user
    if @user.nil?
      redirect_to sign_in_url
    end
  end

  #To show results from help contents
  def search_help
    @helps=Help.find(:all, :conditions=>["keywords ILIKE?", "%#{params[:search_text]}%"])
  end

  #To show get help form
  def new
    find_user
    if @user.nil?
      redirect_to sign_in_url
    else
      @help_request=@user.help_requests.build
    end
  end

  #To send get help request
  def create
    find_user
    if @user.nil?
      redirect_to sign_in_url
    else
      @help_request=@user.help_requests.build(params[:help_request])
      if @help_request.save
        UserMailer.send_help_request(@help_request).deliver
        flash[:notice]= "Support request has been sent."
        redirect_to get_help_url
      else
        render :new
      end
    end
  end

  #To show notification tab under Project Settings page
  def notification_new
    @aclass=""
    find_user
    if !@user.nil?
      assign_project
      @notification=@user.notifications.find_by_project_id(session[:project_id])
      if @notification.nil?
        if !current_user.nil?
          @notification=@user.notifications.create(:project_id=>session[:project_id])
        elsif !current_member.nil?
          @notification=@user.notifications.create(:user_id=>@user.user_id, :project_id=>session[:project_id])
        end
      end
    else
      redirect_to sign_in_url
    end
  end

  #To save ntoifications settings
  def save_notification
    find_user
    if !@user.nil?
      assign_project
      @notification=@user.notifications.find_by_project_id(session[:project_id])
      @notification=@notification.update_attributes(params[:notification])
      redirect_to notification_url
    else
      redirect_to sign_in_url
    end
  end

  #To show attributes tab under Project Settings page
  def attributes_new
    @aclass="" #using for selecting appropriate itoggle css
    @use_css="" #using for selecting appropriate itoggle css
    find_user
    if !@user.nil?
      assign_project
      if !session[:project_id].nil?
        find_all_attribute
        if @attr.nil?
          if !current_user.nil?
            @attr=@project.create_attribute(:user_id=>@user.id)
          else
            @attr=@project.create_attribute(:member_id=>@user.id, :user_id=>@user.user_id)
          end
        end
      end
    else
      redirect_to sign_in_url
    end
  end

  #To save requirement attributes settings
  def save_req_attributes
    find_user
    if !@user.nil?
      assign_project
      find_all_attribute
      @attr=Attribute.find_by_project_id(session[:project_id])
      @attr=@attr.update_attributes(params[:attribute])
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To save use case attributes settings
  def save_use_attributes
    find_user
    if !@user.nil?
      find_all_attribute
      @attr=Attribute.find_by_project_id(session[:project_id])
      @attr=@attr.update_attributes(params[:attribute])
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To distory an actor on attribute page
  def destroy_actor
    find_user
    if !@user.nil?
      actor=Actor.find_by_id(params[:value])
      if !actor.nil?
        actor.destroy
      end
      find_all_attribute
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To create category
  def create_category
    find_user
    if !@user.nil?
      assign_project
      @project=Project.find(session[:project_id])
      if !current_user.nil?
        @category=@project.categories.create(:title=>params[:name], :user_id=>@user.id)
      else
        @category=@project.categories.create(:title=>params[:name], :user_id=>@user.user_id, :member_id=>@user.id)
      end
    end
  end

  #To create category for use case and requirements
  def create_category1
    find_user
    if !@user.nil?
      assign_project
      @project=Project.find(session[:project_id])
      if !current_user.nil?
        @category=@project.categories.create(:title=>params[:name], :user_id=>@user.id)
      else
        @category=@project.categories.create(:title=>params[:name], :user_id=>@user.user_id, :member_id=>@user.id)
      end
    end
  end

  #To update category
  def update_category
    find_user
    if !@user.nil?
      assign_project
      @category=Category.find(params[:id])
      @category.update_attributes(:title=>params[:"category_#{@category.id}"])
      find_all_attribute
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To destroy category
  def destroy_category
    find_user
    if !@user.nil?
      assign_project
      @category=Category.find_by_id(params[:id])
      if !@category.nil?
        @category.destroy
      end
      find_all_attribute
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To create delivery period
  def create_delivery
    find_user
    if !@user.nil?
      assign_project
      @project=Project.find(session[:project_id])
      if !current_user.nil?
        @delivery=@project.delivery_periods.create(:title=>params[:name], :user_id=>@user.id)
      else
        @category=@project.delivery_periods.create(:title=>params[:name], :user_id=>@user.user_id, :member_id=>@user.id)
      end
    else
      redirect_to sign_in_url
    end
  end

  #To update delivery period
  def update_delivery
    find_user
    if !@user.nil?
      assign_project
      @delivery=DeliveryPeriod.find(params[:id])
      @delivery.update_attributes(:title=>params[:"delivery_#{@delivery.id}"])
      find_all_attribute
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To destroy delivery period
  def destroy_delivery
    find_user
    if !@user.nil?
      assign_project
      @delivery=DeliveryPeriod.find_by_id(params[:id])
      if !@delivery.nil?
        @delivery.destroy
      end
      find_all_attribute
      redirect_to attributes_url
    else
      redirect_to sign_in_url
    end
  end

  #To show contact us form
  def contact_form
    @contact=Contact.new
    render :layout => 'signin', :action => "contact_form"
  end

  #To send contact us request
  def thanks
    @contact=Contact.create(params[:contact])
    if @contact.save
      render :layout => 'signin', :action => "thanks"
    else
      render :layout => 'signin', :action => "contact_form"
    end
  end

  #To show requirement catalog report
  def req_catalog_report
    @reqs=Requirement.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "created_at desc")
    @project=Project.find(session[:project_id])
    find_user
    find_first_name(@user)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.font("Helvetica", :size => 12) do
          @projects = @project.project_name.capitalize
          @names= @name.first_name.capitalize
          pdf.formatted_text_box [{:text =>@projects, :color => "FF8C00", :style => :bold}], :at => [70, 635]
          pdf.formatted_text_box [{:text => @names}], :at => [70, 620]
          pdf.formatted_text_box [{:text => @projects+" - REQUIREMENTS ", :color => "191970", :size=>36, :style => :bold}], :at =>[50, 110]
          pdf.formatted_text_box [{:text => "CATALOG", :color => "191970", :size=>36, :character_spacing => -1, :style => :bold}], :at =>[50, 70]
          pdf.formatted_text_box [{:text => "This document lists all of the project requirements.", :size=>11, :color => "ABABAB"}], :at =>[50, 30]
        end
        pdf.stroke do

          pdf.vertical_line 560, 800, :at =>60
          pdf.line_width = 2.5
          pdf.stroke_color "EE7600"
        end
        custom_size = [275, 326]

        pdf.start_new_page(:layout => :portrait)
        pdf.font("Helvetica", :size => 8) do
          @projects = @project.project_name.capitalize
          @names= @name.first_name.capitalize
          pdf.formatted_text_box [{:text =>"Date:"+Time.now.strftime("%d-%m-%Y"), :color => "191970", :style => :bold}]
          pdf.formatted_text_box [{:text => "Author:"+@names, :color => "191970"}], :at =>[0, 710]
          pdf.formatted_text_box [{:text => "["+@projects+"-", :color => "FF8C00", :size=>22}], :at =>[420, 715]
          pdf.formatted_text_box [{:text => "REQUIREMENTS CATALOG]", :color => "FF8C00", :size=>22, :character_spacing => -1}], :at =>[260, 685]
          pdf.move_down 70
          pdf.stroke do
            pdf.horizontal_rule
            pdf.line_width = 0.5
            pdf.stroke_color "191970"
          end
          pdf.formatted_text_box [{:text => "Summary of Requirements", :color => "191970", :size=>16}], :at =>[0, 630]
          pdf.move_down 50
          i=0
          array_size=@reqs.length + 1
          a = Array.new(6) { [] }

          while (i < @reqs.length)
            a[0][i] = @reqs[i-1].id.to_s
            a[1][i] = @reqs[i-1].status
            a[2][i] = @reqs[i-1].name
            a[3][i] = @reqs[i-1].category
            a[4][i] = @reqs[i-1].type1
            i=i+1
          end

          i=0
          @data = [["Req#", "Status", "Requirement Description", "Category", "Type"]]
          while (i < @reqs.length)
            @data += [[a[0][i],
                       a[1][i],
                       a[2][i],
                       a[3][i],
                       a[4][i]]]
            i=i+1
          end
          pdf.table(@data, :header=>true, :column_widths => [30, 50, 180, 120, 160], :cell_style => {:border_color=> "ABABAB", :border_width=>0.8})

        end

        pdf.stroke do
          pdf.horizontal_line 0, 540, :at => 15
          pdf.line_width = 1
          pdf.stroke_color "EE7600"
        end

        pdf.number_pages "Page <page> of <total>", {:start_count_at => 1, :page_filter => lambda { |pg| pg > 1 }, :at => [pdf.bounds.left - 50, 10], :align => :center, :size => 10}
        send_data pdf.render, :filename => 'requirements.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
    #File.open("#{Rails.root}/public/ele-bahq-reqs-catalog.rtf","w") {|file| file.write(document.to_rtf)}

  end

  #To show definitions list report
  def def_list_report
    @defs=Definition.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "term")
    @project=Project.find(session[:project_id])
    find_user
    find_first_name(@user)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.font("Helvetica", :size => 12) do
          @projects = @project.project_name.capitalize
          @names= @name.first_name.capitalize
          pdf.formatted_text_box [{:text =>@projects, :color => "FF8C00", :style => :bold}], :at => [70, 635]
          pdf.formatted_text_box [{:text => @names}], :at => [70, 620]
          pdf.formatted_text_box [{:text => @projects+" - DEFINITIONS ", :color => "191970", :size=>36, :style => :bold}], :at =>[50, 110]
          pdf.formatted_text_box [{:text => "LIST", :color => "191970", :size=>36, :character_spacing => -1, :style => :bold}], :at =>[50, 70]
          pdf.formatted_text_box [{:text => "This document lists all of the project definitions.", :size=>11, :color => "ABABAB"}], :at =>[50, 30]
        end
        pdf.stroke do

          pdf.vertical_line 560, 800, :at =>60
          pdf.line_width = 2.5
          pdf.stroke_color "EE7600"
        end
        custom_size = [275, 326]

        pdf.start_new_page(:layout => :portrait)
        pdf.font("Helvetica", :size => 8) do
          @projects = @project.project_name.capitalize
          @names= @name.first_name.capitalize
          pdf.formatted_text_box [{:text =>"Date:"+Time.now.strftime("%d-%m-%Y"), :color => "191970", :style => :bold}]
          pdf.formatted_text_box [{:text => "Author:"+@names, :color => "191970"}], :at =>[0, 710]
          pdf.formatted_text_box [{:text => "["+@projects+"-", :color => "FF8C00", :size=>22}], :at =>[400, 715]
          pdf.formatted_text_box [{:text => "DEFINITIONS LIST ]", :color => "FF8C00", :size=>22, :character_spacing => -1}], :at =>[320, 685]
          pdf.move_down 70
          pdf.stroke do
            pdf.horizontal_rule
            pdf.line_width = 0.5
            pdf.stroke_color "191970"
          end
          pdf.formatted_text_box [{:text => "Glossary of Terms", :color => "191970", :size=>16}], :at =>[0, 630]
          pdf.move_down 50
          i=0
          array_size=@defs.length + 1
          a = Array.new(6) { [] }

          while (i < @defs.length)
            a[0][i] = @defs[i-1].term
            a[1][i] = @defs[i-1].definition

            i=i+1
          end

          i=0
          @data = [["Term", "Definition"]]
          while (i < @defs.length)
            @data += [[a[0][i],
                       a[1][i]
            ]]
            i=i+1
          end
          pdf.table(@data, :header=>true, :column_widths => [200, 340], :cell_style => {:border_color=> "ABABAB", :border_width=>0.8})

        end

        pdf.stroke do
          pdf.horizontal_line 0, 540, :at => 15
          pdf.line_width = 1
          pdf.stroke_color "EE7600"
        end

        pdf.number_pages "Page <page> of <total>", {:start_count_at => 0, :page_filter => lambda { |pg| pg > 1 }, :at => [pdf.bounds.left - 50, 10], :align => :center, :size => 10}
        send_data pdf.render, :filename => 'definitions.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
    #File.open("#{Rails.root}/public/ele-bahq-reqs-catalog.rtf","w") {|file| file.write(document.to_rtf)}

  end

  #To show traceability matrix report
  def traceability_matrix_report
    @reqs=Requirement.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "created_at desc")
    @use_cases=UseCase.find(:all, :conditions=>["project_id=?", session[:project_id]], :order => "created_at desc")
    @project=Project.find(session[:project_id])
    find_user
    find_first_name(@user)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.font("Helvetica", :size => 12) do
          @projects = @project.project_name.capitalize
          @names= @name.first_name.capitalize
          pdf.formatted_text_box [{:text =>@projects, :color => "FF8C00", :style => :bold}], :at => [70, 635]
          pdf.formatted_text_box [{:text => @names}], :at => [70, 620]
          pdf.formatted_text_box [{:text => @projects+" - TRACEABILITY ", :color => "191970", :size=>36, :style => :bold}], :at =>[50, 110]
          pdf.formatted_text_box [{:text => "MATRIX", :color => "191970", :size=>36, :character_spacing => -1, :style => :bold}], :at =>[50, 70]
          pdf.formatted_text_box [{:text => "This document lists all of the project definitions.", :size=>11, :color => "ABABAB"}], :at =>[50, 30]
        end
        pdf.stroke do

          pdf.vertical_line 560, 800, :at =>60
          pdf.line_width = 2.5
          pdf.stroke_color "EE7600"
        end
        custom_size = [275, 326]

        pdf.start_new_page(:layout => :portrait)
        pdf.font("Helvetica", :size => 8) do
          @projects = @project.project_name.capitalize
          @names= @name.first_name.capitalize
          pdf.formatted_text_box [{:text =>"Date:"+Time.now.strftime("%d-%m-%Y"), :color => "191970", :style => :bold}]
          pdf.formatted_text_box [{:text => "Author:"+@names, :color => "191970"}], :at =>[0, 710]
          pdf.formatted_text_box [{:text => "["+@projects+"-", :color => "FF8C00", :size=>22}], :at =>[400, 715]
          pdf.formatted_text_box [{:text => "TRACEABILITY MATRIX ]", :color => "FF8C00", :size=>22, :character_spacing => -1}], :at =>[280, 685]
          pdf.move_down 70
          pdf.stroke do
            pdf.horizontal_rule
            pdf.line_width = 0.5
            pdf.stroke_color "191970"
          end
          pdf.formatted_text_box [{:text => "TRACEABILITY MATRIX", :color => "191970", :size=>16}], :at =>[0, 630]
          pdf.move_down 50

          a = Array.new(6) { [] }
          a[0][0]="Requirement#"
          i=1
          while (i < @reqs.length+1)
            a[0][i]="REQ_#{@reqs[i-1].id}"
            i=i+1
          end
          a[1][0]="Not applicable"
          j=1
          while (j < @reqs.length+1)
            use_case=@reqs[j-1].use_cases.find :all
            if use_case.empty?
              if @reqs[j-1].type1=="Non Functional"
                a[1][j] = "X"
              else
                a[1][j] = ""
              end

            end
            j=j+1
          end
          i=2

          while (i < @use_cases.length+2)
            a[i][0]="UC_#{@use_cases[i-2].id}"
            j=1
            while (j < @reqs.length+1)
              use_case=@reqs[j-1].use_cases.find(:all, :conditions=>["id=?", @use_cases[i-2].id])
              if !use_case.empty?
                if @reqs[j-1].type1=="Non Functional"
                  a[i][j] = "X"
                  a[1][j] = "X"
                elsif @reqs[j-1].type1=="Functional"
                  a[i][j] = "X"
                end

              else
                a[i][j] =""
              end
              j=j+1
            end
            i=i+1
          end

          i=0

          @data = [["Requirements Traceability Matrix"]]

          pdf.table(@data, :header=>true, :cell_style => {:border_color=> "ABABAB", :border_width=>0.8, :padding_left=>200}, :width=>540)
          pdf.table(a, :header=>true, :cell_style => {:border_color=> "ABABAB", :border_width=>0.8}, :width=>540)

        end

        pdf.stroke do
          pdf.horizontal_line 0, 540, :at => 15
          pdf.line_width = 1
          pdf.stroke_color "EE7600"
        end

        pdf.number_pages "Page <page> of <total>", {:start_count_at => 0, :page_filter => lambda { |pg| pg > 1 }, :at => [pdf.bounds.left - 50, 10], :align => :center, :size => 10}
        send_data pdf.render, :filename => 'traceability.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
    #File.open("#{Rails.root}/public/ele-bahq-reqs-catalog.rtf","w") {|file| file.write(document.to_rtf)}

  end

  #To set toggle on/off
  def on_off
    model_name=""
    if (params[:model_name]=="attribute")
      model_name=Attribute
    elsif (params[:model_name]=="notification")
      model_name=Notification
    end
    id= model_name.find(params[:id])
    model_name.update_all("#{params[:cl_name]}='#{params[:off]}'", ['project_id=?', id.project_id])
  end

  #To show FAQ
  def show_faq
    @help=Help.find(params[:id])
    respond_to do |format|
      format.html { render "show_faq" }
    end
  end
  private

  #To check user infromation
  def find_user
    if !current_user.nil?
      @user=User.find(current_user.id)
      @subscriber_id=@user.id
      session[:admin_id]=@user.id
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      @subscriber_id=@user.user_id
      session[:admin_id]=@user.user_id
    end
  end

  #To check all attributes related to a project
  def find_all_attribute

    @project=Project.find(session[:project_id])
    @actors=@project.find_actor(@project)
    @attr=Attribute.find_by_project_id(session[:project_id])
    @categories=@project.categories.find :all
    @deliveries=@project.delivery_periods.find :all


  end

  #To find first name of subscriber
  def find_first_name(user)
    if !current_user.nil?
      @name=Address.find_by_user_id(user.id, :select=>"first_name")
    else
      @name=user
    end
  end

  #To assign a project
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


end
