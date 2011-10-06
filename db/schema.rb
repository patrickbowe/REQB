# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111006121816) do

  create_table "actors", :force => true do |t|
    t.text     "title"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "billing_address"
    t.string   "city"
    t.integer  "zip"
    t.string   "region"
    t.string   "country"
    t.string   "phone"
    t.integer  "user_id"
    t.boolean  "newsletter",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alternate_basic_flows", :force => true do |t|
    t.text     "action"
    t.text     "response"
    t.integer  "alternate_flow_id"
    t.integer  "seq_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alternate_flows", :force => true do |t|
    t.text     "title"
    t.integer  "basic_flow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "basic_flows", :force => true do |t|
    t.text     "action"
    t.text     "response"
    t.integer  "use_case_id"
    t.integer  "seq_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_rules", :force => true do |t|
    t.text     "title"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "title"
    t.integer  "user_id"
    t.integer  "tracker_id"
    t.integer  "requirement_id"
    t.integer  "use_case_id"
    t.integer  "member_id"
    t.integer  "project_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "definitions", :force => true do |t|
    t.text     "term"
    t.text     "definition"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "help_requests", :force => true do |t|
    t.integer  "member_id"
    t.integer  "user_id"
    t.string   "sender_email"
    t.text     "email_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", :force => true do |t|
    t.text     "faq"
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                         :null => false
    t.string   "crypted_password",                              :null => false
    t.string   "password_salt",                                 :null => false
    t.string   "persistence_token",                             :null => false
    t.string   "single_access_token",                           :null => false
    t.string   "perishable_token",                              :null => false
    t.integer  "login_count",         :default => 0,            :null => false
    t.integer  "failed_login_count",  :default => 0,            :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "newsletter"
    t.integer  "user_id"
    t.integer  "member_id"
    t.string   "privilige",           :default => "Read/Write"
    t.boolean  "active",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notify",              :default => false
  end

  create_table "messages", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "plan_type"
    t.integer  "project_count"
    t.string   "storage"
    t.integer  "member_count"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_conditions", :force => true do |t|
    t.text     "title"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pre_conditions", :force => true do |t|
    t.text     "title"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_files", :force => true do |t|
    t.string   "type1"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
  end

  create_table "project_files_requirements", :id => false, :force => true do |t|
    t.integer "project_file_id"
    t.integer "requirement_id"
  end

  create_table "project_files_trackers", :id => false, :force => true do |t|
    t.integer "project_file_id"
    t.integer "tracker_id"
  end

  create_table "project_files_use_cases", :id => false, :force => true do |t|
    t.integer "project_file_id"
    t.integer "use_case_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "project_name"
    t.text     "description"
    t.text     "path"
    t.integer  "user_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirements", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.string   "category"
    t.string   "type1"
    t.integer  "project_id"
    t.string   "importance"
    t.string   "priority"
    t.string   "verification"
    t.integer  "user_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirements_trackers", :id => false, :force => true do |t|
    t.integer "requirement_id"
    t.integer "tracker_id"
  end

  create_table "requirements_use_cases", :id => false, :force => true do |t|
    t.integer "requirement_id"
    t.integer "use_case_id"
  end

  create_table "success_conditions", :force => true do |t|
    t.text     "title"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trackers", :force => true do |t|
    t.text     "title"
    t.string   "category"
    t.string   "assigned"
    t.string   "due",          :limit => nil
    t.boolean  "flag_tracker"
    t.integer  "member_id"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trackers_use_cases", :id => false, :force => true do |t|
    t.integer "tracker_id"
    t.integer "use_case_id"
  end

  create_table "triggers", :force => true do |t|
    t.text     "title"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "use_case_details", :force => true do |t|
    t.text     "pre_conditions"
    t.text     "post_conditions"
    t.text     "success_conditions"
    t.text     "triggers"
    t.text     "actors"
    t.integer  "use_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "use_cases", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "status"
    t.string   "category"
    t.text     "goal"
    t.integer  "user_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_plans", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.integer  "project_count", :default => 0
    t.integer  "storage",       :default => 0
    t.integer  "member_count",  :default => 0
    t.text     "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",                         :null => false
    t.string   "password_salt",                            :null => false
    t.string   "persistence_token",                        :null => false
    t.string   "single_access_token",                      :null => false
    t.string   "perishable_token",                         :null => false
    t.integer  "login_count",         :default => 0,       :null => false
    t.integer  "failed_login_count",  :default => 0,       :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",              :default => false
    t.string   "privilige",           :default => "Admin"
  end

end
