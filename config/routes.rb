Project2::Application.routes.draw do
  get "dashboards/new"

  resources :homes
  root :to => "homes#index"
  match "homes/search_text" => "homes#search_text" ,:as => :search
  match "dashboard" => "homes#dashboard" ,:as => :dashboard
  match "get_help" => "homes#get_help" ,:as => :get_help
  match "homes/search_help/:search_text" => "homes#search_help"

  resources :projects
  get "projects/create/:project_name" => "projects#create",:via => :get
  #match "projects/create" => "projects#create"
  match "projects/update_project_name/:project_id"=>"projects#update_project_name"
  match "projects/:id/edit" => "projects#edit"
  match "projects/destroy/:id" => "projects#destroy",:as => :delete

  resources :requirements
  get "requirements/create/:req_name" => "requirements#create",:via => :get
  match "requirements/:id/edit" => "requirements#edit"
  match "requirements/create_requirements" => "requirements#create_requirements"
  match "requirements/show_use_case/:req" => "requirements#show_use_case",:as=> :show_usecases
  match "requirements/destroy/:id" => "requirements#destroy",:as => :delete_req
  get "requirements/create_requirement_use/:requirement" => "requirements#create_requirement_use",:via => :get
  match "requirements/destroy_requirement_use/:id" => "requirements#destroy_requirement_use",:as => :delete_req_use
  match "requirements/edit_requirement_use/:id" => "requirements#edit_requirement_use",:as => :edit_req_use
  match "requirements/show_tracker/:req" => "requirements#show_tracker",:as=> :show_trackers
  match "requirements/create_comment/:comment/:id" => "requirements#create_comment"
  match "requirements/delete_comment/:id" => "requirements#delete_comment",:as=> :delete_comment
  match "requirements/show_file/:req" => "requirements#show_file",:as=> :show_files
  match "requirements/sort_requirement/:name" => "requirements#sort_requirement"
  match "requirements/match_requirement_name/:char" => "requirements#match_requirement_name",:via => :get
  #get "home/index"


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

  resources :user_sessions
  get "user_sessions/new"

  resource :account, :controller => "users"
  match 'account_details' => "homes#account_details",:as=> :account_details
  match 'change_password' => "users#change_password",:as=> :change_password
  match 'change_email' => "users#change_email",:as=> :change_email  

  resources :password_resets
  match 'password_resets/create_password' => 'password_resets#create_password'

  resources :payments
  match 'payments/create' => 'payments#create'


  resources :use_cases
  get "use_cases/create/:use_case_name" => "use_cases#create",:via => :get
  get "use_cases/req_create/:use_case_name" => "use_cases#req_create",:via => :get
  match "use_cases/:id/edit" => "use_cases#edit" ,:as=>:edit
  match "use_cases/edit_req_usecase/:id" => "use_cases#edit_req_usecase"
  match "use_cases/destroy_req_usecase/:id" => "use_cases#destroy_req_usecase"
  match "use_cases/show_req/:id" => "use_cases#show_req",:as=> :show_requirements
  match "use_cases/show_tracker_use/:use" => "use_cases#show_tracker_use",:as=> :show_trackers_use
  match "use_cases/create_comment/:comment/:id" => "use_cases#create_comment"
  match "use_cases/delete_comment/:id" => "use_cases#delete_comment",:as=> :delete_comment_usecase
  match "use_cases/match_usecase_name/:char" => "use_cases#match_usecase_name",:via => :get
  match "use_cases/sort_usecase/:name" => "use_cases#sort_usecase"

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

  resources :use_case_details
    get "use_case_details/create_pre_condition/:pre" => "use_case_details#create_pre_condition",:via => :get
    match "use_case_details/delete_pre_condition/:value" => "use_case_details#delete_pre_condition",:as=> :delete_pre
    match "use_case_details/edit_pre_condition/:id" => "use_case_details#edit_pre_condition",:as=> :edit_pre

    match "post_conditions" => "use_case_details#index_post_conditions" ,:as => :post_conditions
    get "use_case_details/create_post_condition/:post" => "use_case_details#create_post_condition",:via => :get
    match "use_case_details/delete_post_condition/:value" => "use_case_details#delete_post_condition",:as=> :delete_post
    match "use_case_details/edit_post_condition/:id" => "use_case_details#edit_post_condition",:as=> :edit_post

    match "success_conditions" => "use_case_details#index_success_conditions" ,:as => :success_conditions
    get "use_case_details/create_success_condition/:succ" => "use_case_details#create_success_condition",:via => :get
    match "use_case_details/delete_success_condition/:value" => "use_case_details#delete_success_condition",:as=> :delete_success
    match "use_case_details/edit_succ_condition/:id" => "use_case_details#edit_succ_condition",:as=> :edit_succ

    match "triggers" => "use_case_details#index_triggers" ,:as => :triggers
    get "use_case_details/create_trigger/:trigger" => "use_case_details#create_trigger",:via => :get
    match "use_case_details/delete_trigger/:value" => "use_case_details#delete_trigger",:as=> :delete_trigger
    match "use_case_details/edit_trigger_condition/:id" => "use_case_details#edit_trigger_condition",:as=> :edit_trigger

    match "actors" => "use_case_details#index_actors" ,:as => :actors
    get "use_case_details/create_actor/:actor" => "use_case_details#create_actor",:via => :get
    match "use_case_details/delete_actor/:value" => "use_case_details#delete_actor",:as=> :delete_actor
    match "use_case_details/edit_actor/:id" => "use_case_details#edit_actor",:as=> :edit_actor

    match "business_rules" => "use_case_details#index_business_rules" ,:as => :business_rules
    get "use_case_details/create_business_rule/:rule" => "use_case_details#create_business_rule",:via => :get
    match "use_case_details/delete_business_rule/:id" => "use_case_details#delete_business_rule",:as=> :delete_business_rule
    match "use_case_details/edit_business_rule/:id" => "use_case_details#edit_business_condition",:as=> :edit_business

    match "message" => "use_case_details#index_messages" ,:as => :message
    get "use_case_details/create_message/:msg" => "use_case_details#create_message",:via => :get
    match "use_case_details/delete_message/:id" => "use_case_details#delete_message",:as=> :delete_message
    match "use_case_details/:id/edit" => "use_case_details#edit",:as => :edit

    match "basic_flow" => "use_case_details#index_basic_flows" ,:as => :basic_flow
    get "use_case_details/create_basic_flow/:action1" => "use_case_details#create_basic_flow",:via => :get
    match "use_case_details/create_basic_flow1/:action1/:response1" => "use_case_details#create_basic_flow1"
    match "use_case_details/create_basic_flow2/:response1" => "use_case_details#create_basic_flow2"
    match "use_case_details/delete_basic_flow/:id" => "use_case_details#delete_basic_flow",:as=> :delete_basic_flow
    match "use_case_details/edit_basic_flow/:id" => "use_case_details#edit_basic_flow",:as => :edit_basic_flow

    match "alternate_flow" => "use_case_details#index_alternate_flows" ,:as => :alternate_flow
    get "use_case_details/create_alter_flow/:title" => "use_case_details#create_alter_flow",:via => :get
    match "use_case_details/delete_alternate_flow/:id" => "use_case_details#delete_alternate_flow",:as=> :delete_alternate
    match "use_case_details/edit_alternate_flow/:id" => "use_case_details#edit_alternate_flow",:as=> :edit_alternate
    get "use_case_details/create_alter_basic_flow/:action1/:id" => "use_case_details#create_alter_basic_flow",:via => :get
    match "use_case_details/create_alter_basic_flow1/:action1/:response1/:id" => "use_case_details#create_alter_basic_flow1"
    match "use_case_details/create_alter_basic_flow2/:response1/:id" => "use_case_details#create_alter_basic_flow2"
    match "use_case_details/delete_alter_basic_flow/:id" => "use_case_details#delete_alter_basic_flow",:as=> :delete_alter_basic_flow
    match "use_case_details/edit_alter_basic_flow/:id" => "use_case_details#edit_alter_basic_flow",:as => :edit_alter_basic_flow

  resources :trackers
   get "trackers/create/:tracker_name" => "trackers#create",:via => :get
   match "trackers/:id/edit" => "trackers#edit",:as=>:edit
   match "trackers/tracker_flag/:tracker_flag/:id" => "trackers#tracker_flag"
   get "trackers/create_tracker_req/:tracker_name" => "trackers#create_tracker_req",:via => :get
   match "trackers/destroy_tracker_req/:id" => "trackers#destroy_tracker_req",:as => :delete_tracker_req
   match "trackers/edit_tracker_req/:id" => "trackers#edit_tracker_req",:as => :edit_tracker_req
   get "trackers/create_tracker_use/:tracker_name" => "trackers#create_tracker_use",:via => :get
   match "trackers/destroy_tracker_use/:id" => "trackers#destroy_tracker_use",:as => :delete_tracker_use
   match "trackers/edit_tracker_use/:id" => "trackers#edit_tracker_use",:as => :edit_tracker_use
   match "trackers/create_comment/:comment/:id" => "trackers#create_comment"
   match "trackers/delete_comment/:id" => "trackers#delete_comment",:as=> :delete_comment_tracker
   match "trackers/match_tracker_name/:char" => "trackers#match_tracker_name",:via => :get
   match "trackers/sort_tracker/:name" => "trackers#sort_tracker"

  resources :definitions
  get "definitions/create_term/:term/:def" => "definitions#create_term",:via => :get
  match "definitions/destroy_def/:id" => "definitions#destroy_def",:as => :delete_def
  match "definitions/edit_def/:id" => "definitions#edit_def",:as => :edit_def
  match "definitions/sort_def/:name" => "definitions#sort_def"
   match "definitions/search_def/:name" => "definitions#search_def"
  #match "members/notification_confirmation/:id" => "members#notification_confirmation",:as=>:notification
  #match "members/create/:email" => "members#create"
  #root :controller => "user_sessions", :action => "new"

  resources :project_files
    match "project_files/:id/edit" => "project_files#edit"
    match "project_files/create_comment/:comment/:id" => "project_files#create_comment"
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
end

