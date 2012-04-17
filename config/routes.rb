Project2::Application.routes.draw do
  get "dashboards/new"


  match "homes/on_off" => "homes#on_off"
  resources :homes
  root :to => "homes#index" 
  match "homes/search_text" => "homes#search_text" ,:as => :search
  match "users/signup_complete" => "users#signup_complete" ,:as => :signup_complete
  match "dashboard" => "homes#dashboard" ,:as => :dashboard
  match "get_help" => "homes#get_help" ,:as => :get_help
  match "homes/search_help/:search_text" => "homes#search_help"
  match "notification_new" => "homes#notification_new",:as=> :notification
  match "save_notification" => "homes#save_notification",:as=> :save_notification
  match "attributes_new" => "homes#attributes_new",:as=> :attributes
  match "save_req_attributes" => "homes#save_req_attributes",:as=> :save_req_attributes
  match "save_use_attributes" => "homes#save_use_attributes",:as=> :save_use_attributes
  match "destroy_actor/:value" => "homes#destroy_actor",:as=> :destroy_actor
  get "homes/create_category/:name" => "homes#create_category",:via => :get
  get "homes/create_category1/:name" => "homes#create_category1",:via => :get
  match "homes/update_category" => "homes#update_category",:as=>:update_category
  match "homes/destroy_category/:id" => "homes#destroy_category",:as=>:destroy_category
  get "homes/create_delivery/:name" => "homes#create_delivery",:via => :get
  match "homes/update_delivery/:id" => "homes#update_delivery",:as=>:update_delivery
  match "homes/destroy_delivery/:id" => "homes#destroy_delivery",:as=>:destroy_delivery
  match "homes/dismiss_notification/:id" => "homes#dismiss_notification"
  match "homes/complete_due_tracker/:id" => "homes#complete_due_tracker"
  match "homes/delete_tracker/:id" => "homes#delete_tracker"
  match "homes/complete_assigned_tracker/:id" => "homes#complete_assigned_tracker"
  match "homes/delete_assigned_tracker/:id" => "homes#delete_assigned_tracker"
  match "terms_of_service" => "homes#terms_of_service"
  match "price-list" => "homes#pricing_list",:as => :price_list
  match "dismiss-dashboard" => "homes#dismiss_dashboard",:as => :dismiss_dashboard
  match "homes/set_dismiss_dashboard_flag/:flag" => "homes#set_dismiss_dashboard_flag"
  match "contact" => "homes#contact_form",:as=> :contact
  match "thanks" => "homes#thanks",:as=>:contact_form
  match "requirement_catalog_report" => "homes#req_catalog_report",:as=>:req_catalog_report
  match "definition_report" => "homes#def_list_report",:as=>:def_list_report
  match "traceability_report" => "homes#traceability_matrix_report",:as=>:traceability_report
  match "users/check_domain/:subdomain"=>"users#check_domain",:via => :get
  match "homes/show_faq/:id" => "homes#show_faq",:as=>:show_faq

  match "projects/create" => "projects#create"
  resources :projects
  match "projects/update_project_name/:project_id"=>"projects#update_project_name"
  match "projects/:id/edit" => "projects#edit"
  match "projects/destroy/:id" => "projects#destroy",:as => :delete

  match "requirements/create" => "requirements#create"
  match "requirements/create_requirement_use" => "requirements#create_requirement_use"
  match "requirements/create_requirement_file" => "requirements#create_requirement_file"
  match "requirements/create_requirement_tracker" => "requirements#create_requirement_tracker"
  match "requirements/create_comment" => "requirements#create_comment"
  resources :requirements
  match "requirements/edit/:id" => "requirements#edit",:as=> :edit_req
  match "requirements/create_requirements" => "requirements#create_requirements"
  match "requirements/show_use_case/:req" => "requirements#show_use_case",:as=> :show_usecases
  match "requirements/destroy/:id" => "requirements#destroy",:as => :delete_req
  match "requirements/destroy_requirement_use/:id" => "requirements#destroy_requirement_use",:as => :delete_req_use
  match "requirements/edit_requirement_use/:id" => "requirements#edit_requirement_use",:as => :edit_req_use
  match "requirements/show_tracker/:req" => "requirements#show_tracker",:as=> :show_trackers
  match "requirements/delete_comment/:id" => "requirements#delete_comment",:as=> :delete_comment
  match "requirements/show_file/:req" => "requirements#show_file",:as=> :show_files
  match "requirements/sort_requirement/:name" => "requirements#sort_requirement"
  match "requirements/match_requirement_name/:char" => "requirements#match_requirement_name",:via => :get
  match "requirements/update_comment" => "requirements#update_comment",:as => :update_comment
  match "requirements/destroy_requirement_file/:id" => "requirements#destroy_requirement_file",:as => :delete_req_file
  match "requirements/edit_requirement_file/:id" => "requirements#edit_requirement_file",:as => :edit_req_file
  match "requirements/destroy_requirement_tracker/:id" => "requirements#destroy_requirement_tracker",:as => :delete_req_tracker
  match "requirements/edit_requirement_tracker/:id" => "requirements#edit_requirement_tracker",:as => :edit_req_tracker

  #get "home/index"

  get 'users/check_email' => 'users#check_email'
  resources :users
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  get 'reset_password/:reset_password_code' => 'users#reset_password', :as => :reset_password, :via => :get
  put 'reset_password/:reset_password_code' => 'users#reset_password_submit', :as => :reset_password, :via => :put
  match 'activate(/:activation_code)' => 'users#activate', :as => :activate_account
  match 'send_activation(/:user_id)' => 'users#send_activation', :as => :send_activation
  get 'user_setting' => 'users#user_setting'
  post 'users/:id' => 'payments#create', :as => :create, :via => :post
  match 'update_email' => 'users#update_email',:as=> :update_email,:via=> :get
  match 'resend_activation_link' => 'users#resend_activation_link',:as=> :resend_activation
  match "use_cases/show_file_use/:use" => "use_cases#show_file_use",:as=> :show_files_use
  match "use_cases/destroy_usecase_file/:id" => "use_cases#destroy_usecase_file",:as => :delete_use_file
  match "use_cases/edit_usecase_file/:id" => "use_cases#edit_usecase_file",:as => :edit_use_file
  match "sign-up" => "users#new",:as=> :sign_up


  resources :user_sessions
  match "sign-in" => "user_sessions#new",:as=> :sign_in

  resource :account, :controller => "users"
  match 'account_details' => "homes#account_details",:as=> :account_details
  match 'change_password' => "users#change_password",:as=> :change_password
  match 'change_email' => "users#change_email",:as=> :change_email
  match 'change_subscription' => "users#change_subscription",:as=> :change_subscription
  match 'verify_subscription' => "users#verify_subscription",:as=> :verify_subscription


  resources :password_resets
  match 'password_resets/create_password' => 'password_resets#create_password'

  resources :payments
  match 'payments/create' => 'payments#create'

  match "use_cases/create" => "use_cases#create"
  match "use_cases/req_create" => "use_cases#req_create"
  match "use_cases/tracker_create" => "use_cases#tracker_create"
  match "use_cases/create_usecase_file" => "use_cases#create_usecase_file"
  resources :use_cases
  match "use_cases/:id/edit" => "use_cases#edit" ,:as=>:edit
  match "use_cases/destroy/:id" => "use_cases#destroy",:as => :delete_use
  match "use_cases/edit_req_usecase/:id" => "use_cases#edit_req_usecase",:as => :edit_req_usecase
  match "use_cases/destroy_req_usecase/:id" => "use_cases#destroy_req_usecase"
  match "use_cases/show_req/:id" => "use_cases#show_req",:as=> :show_requirements
  match "use_cases/show_tracker_use/:use" => "use_cases#show_tracker_use",:as=> :show_trackers_use
  match "use_cases/create_comment/:comment/:id" => "use_cases#create_comment"
  match "use_cases/delete_comment/:id" => "use_cases#delete_comment",:as=> :delete_comment_usecase
  match "use_cases/match_usecase_name/:char" => "use_cases#match_usecase_name",:via => :get
  match "use_cases/sort_usecase/:name" => "use_cases#sort_usecase"
  match "use_cases/update_use_comment" => "use_cases#update_use_comment",:as => :update_use_comment
  match "use_cases/edit_tracker_usecase/:id" => "use_cases#edit_tracker_usecase",:as => :edit_tracker_usecase
  match "use_cases/destroy_tracker_usecase/:id" => "use_cases#destroy_tracker_usecase"

  resources :members
  match "members/create/:member_email1" => "members#create",:via => :get
  get 'member_activation/:member_activation_code' => 'members#member_activation', :as => :member_activation, :via => :get
  put 'member_activation/:member_activation_code' => 'members#member_activation_submit', :as => :member_activation, :via => :put
  match "members/:id/edit" => "members#edit",:as=>:edit
  get 'notify/:id' => 'members#notify', :as => :notify, :via => :get
  match 'members/notification_confirmation/:id' => 'members#notification_confirmation', :as => :notification_confirmation
  match 'update_email_member' => 'members#update_email_member',:as=> :update_email_member,:via=> :get
   match 'change_email_member' => "members#change_email_member",:as=> :change_email_member
  #match 'member_login' => 'member/member_sessions#new', :as => :member_login
  #match 'member_logout' => 'member/member_sessions#destroy', :as => :member_logout

  namespace :member do
    resources :member_sessions
    resources :dashboards
  end
   match "/use_case_details/seq_change/:seq/:id2" => "use_case_details#seq_change"
   match "/use_case_details/seq_change1/:seq/:id2" => "use_case_details#seq_change1"
   match "use_case_details/create_pre_condition" => "use_case_details#create_pre_condition"
   match "use_case_details/create_post_condition" => "use_case_details#create_post_condition"
   match "use_case_details/create_success_condition" => "use_case_details#create_success_condition"
   match "use_case_details/create_trigger" => "use_case_details#create_trigger"
   match "use_case_details/create_business_rule" => "use_case_details#create_business_rule"
   match "use_case_details/create_message" => "use_case_details#create_message"
   match "use_case_details/create_basic_flow1" => "use_case_details#create_basic_flow1"
   match "use_case_details/create_basic_flow" => "use_case_details#create_basic_flow"
   match "use_case_details/create_basic_flow2" => "use_case_details#create_basic_flow2"
   match "use_case_details/create_alter_flow" => "use_case_details#create_alter_flow"
   match "use_case_details/create_alter_basic_flow" => "use_case_details#create_alter_basic_flow"
   match "use_case_details/create_alter_basic_flow1" => "use_case_details#create_alter_basic_flow1"
   match "use_case_details/create_alter_basic_flow2" => "use_case_details#create_alter_basic_flow2"
  resources :use_case_details

    match "use_case_details/delete_pre_condition/:value" => "use_case_details#delete_pre_condition",:as=> :delete_pre
    match "use_case_details/edit_pre_condition/:id" => "use_case_details#edit_pre_condition",:as=> :edit_pre
    match "use_case_details/show_pre_condition/:id" => "use_case_details#show_pre_condition",:as => :show_pre_condition

    match "post_conditions" => "use_case_details#index_post_conditions" ,:as => :post_conditions
    match "use_case_details/delete_post_condition/:value" => "use_case_details#delete_post_condition",:as=> :delete_post
    match "use_case_details/edit_post_condition/:id" => "use_case_details#edit_post_condition",:as=> :edit_post

    match "success_conditions" => "use_case_details#index_success_conditions" ,:as => :success_conditions
    match "use_case_details/delete_success_condition/:value" => "use_case_details#delete_success_condition",:as=> :delete_success
    match "use_case_details/edit_succ_condition/:id" => "use_case_details#edit_succ_condition",:as=> :edit_succ

    match "triggers" => "use_case_details#index_triggers" ,:as => :triggers
    match "use_case_details/delete_trigger/:value" => "use_case_details#delete_trigger",:as=> :delete_trigger
    match "use_case_details/edit_trigger_condition/:id" => "use_case_details#edit_trigger_condition",:as=> :edit_trigger

    match "actors" => "use_case_details#index_actors" ,:as => :actors
    get "use_case_details/create_actor/:actor" => "use_case_details#create_actor",:via => :get
    match "use_case_details/delete_actor/:value" => "use_case_details#delete_actor",:as=> :delete_actor
    match "use_case_details/edit_actor/:id" => "use_case_details#edit_actor",:as=> :edit_actor

    match "business_rules" => "use_case_details#index_business_rules" ,:as => :business_rules
    match "use_case_details/delete_business_rule/:id" => "use_case_details#delete_business_rule",:as=> :delete_business_rule
    match "use_case_details/edit_business_rule/:id" => "use_case_details#edit_business_condition",:as=> :edit_business

    match "message" => "use_case_details#index_messages" ,:as => :message
    match "use_case_details/delete_message/:id" => "use_case_details#delete_message",:as=> :delete_message
    match "use_case_details/edit_message/:id" => "use_case_details#edit_message",:as => :edit_message

    match "basic_flow" => "use_case_details#index_basic_flows" ,:as => :basic_flow
    match "use_case_details/delete_basic_flow/:id" => "use_case_details#delete_basic_flow",:as=> :delete_basic_flow
    match "use_case_details/edit_basic_flow/:id" => "use_case_details#edit_basic_flow",:as => :edit_basic_flow
    match "use_case_details/show_basic_flows/:id" => "use_case_details#show_basic_flows",:as => :show_basic_flow

    match "alternate_flow" => "use_case_details#index_alternate_flows" ,:as => :alternate_flow

    match "use_case_details/delete_alternate_flow/:id" => "use_case_details#delete_alternate_flow",:as=> :delete_alternate
    match "use_case_details/edit_alternate_flow/:id" => "use_case_details#edit_alternate_flow",:as=> :edit_alternate
    match "use_case_details/delete_alter_basic_flow/:id" => "use_case_details#delete_alter_basic_flow",:as=> :delete_alter_basic_flow
    match "use_case_details/edit_alter_basic_flow/:id/:action1/:response1" => "use_case_details#edit_alter_basic_flow",:as => :edit_alter_basic_flow
    match "use_case_details/show_alter_flow/:id" => "use_case_details#show_alter_flow",:as => :show_alter_flow


   match "trackers/create" => "trackers#create"
   match "trackers/create_tracker_req" => "trackers#create_tracker_req"
   match "trackers/create_tracker_use" => "trackers#create_tracker_use"

  match "trackers/create_comment" => "trackers#create_comment"
  resources :trackers

   match "trackers/:id/edit" => "trackers#edit",:as=>:edit
   match "trackers/tracker_flag/:tracker_flag/:id" => "trackers#tracker_flag"
   match "trackers/tracker_flag_usecase/:tracker_flag/:id" => "trackers#tracker_flag_usecase"
   match "trackers/tracker_flag_req/:tracker_flag/:id" => "trackers#tracker_flag_req"
   match "trackers/destroy_tracker_req/:id" => "trackers#destroy_tracker_req",:as => :delete_tracker_req
   match "trackers/edit_tracker_req/:id" => "trackers#edit_tracker_req",:as => :edit_tracker_req
   match "trackers/destroy_tracker_use/:id" => "trackers#destroy_tracker_use",:as => :delete_tracker_use
   match "trackers/edit_tracker_use/:id" => "trackers#edit_tracker_use",:as => :edit_tracker_use
   match "trackers/delete_comment/:id" => "trackers#delete_comment",:as=> :delete_comment_tracker
   match "trackers/match_tracker_name/:char" => "trackers#match_tracker_name",:via => :get
   match "trackers/sort_tracker/:name" => "trackers#sort_tracker"
   match "trackers/update_tracker_comment" => "trackers#update_tracker_comment",:as => :update_tracker_comment
   match "trackers/show_requirements/:id" => "trackers#show_requirements",:as=> :show_tracker_requirements
   match "trackers/show_req/:id" => "trackers#show_req",:as=> :show_tracker_req
   match "trackers/show_use_case/:id" => "trackers#show_use_case",:as=> :show_tracker_use

  match "definitions/create_term" => "definitions#create_term"
  resources :definitions
  match "definitions/destroy_def/:id" => "definitions#destroy_def",:as => :delete_def
  match "definitions/edit_def/:id" => "definitions#edit_def",:as => :edit_def
  match "definitions/sort_def/:name" => "definitions#sort_def"
  match "definitions/search_def/:name" => "definitions#search_def"
  #match "members/notification_confirmation/:id" => "members#notification_confirmation",:as=>:notification
  #match "members/create/:email" => "members#create"
  #root :controller => "user_sessions", :action => "new"

  match "project_files/create_comment" => "project_files#create_comment"
  resources :project_files
    match "project_files/:id/edit" => "project_files#edit"
    match "project_files/delete_comment/:id" => "project_files#delete_comment",:as=> :delete_file_comment
    match "project_files/match_file_name/:char" => "project_files#match_file_name",:via => :get
    match "project_files/create_link_req/:file_name/:ext1" => "project_files#create_link_req"
    match "project_files/edit_file_req/:id" => "project_files#edit_file_req",:as=> :edit_file_req
    match "project_files/destroy_file_req/:id" => "project_files#destroy_file_req",:as=> :destroy_file_req
    match "project_files/sort_file/:name" => "project_files#sort_file"
    match "project_files/create_link_use/:file_name/:ext1" => "project_files#create_link_use"
    match "project_files/edit_file_use/:id" => "project_files#edit_file_use",:as=> :edit_file_use
    match "project_files/destroy_file_use/:id" => "project_files#destroy_file_use",:as=> :destroy_file_use
    match "project_files/edit_file_req/:id" => "project_files#edit_tracker_req",:as => :edit_file_req
    match "project_files/edit_file_use/:id" => "project_files#edit_tracker_req",:as => :edit_file_use
    match "project_files/update_file_comment" => "project_files#update_file_comment",:as => :update_file_comment
    match "project_files/show_req/:id" => "project_files#show_req",:as=> :show_file_reqs
    match "project_files/show_use/:id" => "project_files#show_use",:as=> :show_file_uses
    match "project_files/create_req_file" => "project_files#create_req_file",:as=> :create_req_file
    match "project_files/create_use_file" => "project_files#create_use_file",:as=> :create_use_file

  resources :statics
    get 'footer_partial' => "statics#footer_partial" ,:as=> :footer_partial
    get 'middle_partial' => "statics#footer_partial" ,:as=> :footer_partial

end


