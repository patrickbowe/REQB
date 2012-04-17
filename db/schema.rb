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

ActiveRecord::Schema.define(:version => 20120410063908) do

  create_table "actors", :force => true do |t|
    t.text      "title"
    t.integer   "use_case_id"
    t.integer   "project_id"
    t.boolean   "flag",        :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.string    "first_name"
    t.string    "last_name"
    t.text      "billing_address"
    t.string    "city"
    t.integer   "zip"
    t.string    "region"
    t.string    "country"
    t.string    "phone"
    t.integer   "user_id"
    t.boolean   "newsletter",       :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "subscription_url"
  end

  create_table "alternate_basic_flows", :force => true do |t|
    t.text      "action"
    t.text      "response"
    t.integer   "alternate_flow_id"
    t.integer   "seq_number"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "alternate_flows", :force => true do |t|
    t.text      "title"
    t.integer   "basic_flow_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "attributes", :force => true do |t|
    t.boolean   "req_status",       :default => true
    t.boolean   "req_priority",     :default => true
    t.boolean   "req_importance",   :default => true
    t.boolean   "req_category",     :default => true
    t.boolean   "req_type",         :default => true
    t.boolean   "req_verification", :default => true
    t.boolean   "req_delivered",    :default => true
    t.boolean   "use_status",       :default => true
    t.boolean   "use_priority",     :default => true
    t.boolean   "use_importance",   :default => true
    t.boolean   "use_category",     :default => true
    t.boolean   "use_goal",         :default => true
    t.boolean   "use_delivered",    :default => true
    t.integer   "project_id"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "basic_flows", :force => true do |t|
    t.text      "action"
    t.text      "response"
    t.integer   "use_case_id"
    t.integer   "seq_number"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "business_rules", :force => true do |t|
    t.text      "title"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.text      "title"
    t.integer   "project_id"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "cms_blocks", :force => true do |t|
    t.integer   "page_id"
    t.string    "label"
    t.text      "content"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "cms_blocks", ["page_id", "label"], :name => "index_cms_blocks_on_page_id_and_label"

  create_table "cms_categories", :force => true do |t|
    t.string "label"
    t.string "categorized_type"
  end

  add_index "cms_categories", ["categorized_type", "label"], :name => "index_cms_categories_on_categorized_type_and_label", :unique => true

  create_table "cms_categorizations", :force => true do |t|
    t.integer "category_id"
    t.string  "categorized_type"
    t.integer "categorized_id"
  end

  add_index "cms_categorizations", ["category_id", "categorized_type", "categorized_id"], :name => "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", :unique => true

  create_table "cms_files", :force => true do |t|
    t.integer   "site_id"
    t.integer   "block_id"
    t.string    "label"
    t.string    "file_file_name"
    t.string    "file_content_type"
    t.integer   "file_file_size"
    t.string    "description",       :limit => 2048
    t.integer   "position",                          :default => 0, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "cms_files", ["site_id", "block_id"], :name => "index_cms_files_on_site_id_and_block_id"
  add_index "cms_files", ["site_id", "file_file_name"], :name => "index_cms_files_on_site_id_and_file_file_name"
  add_index "cms_files", ["site_id", "label"], :name => "index_cms_files_on_site_id_and_label"
  add_index "cms_files", ["site_id", "position"], :name => "index_cms_files_on_site_id_and_position"

  create_table "cms_layouts", :force => true do |t|
    t.integer   "site_id"
    t.integer   "parent_id"
    t.string    "app_layout"
    t.string    "label"
    t.string    "slug"
    t.text      "content"
    t.text      "css"
    t.text      "js"
    t.integer   "position",   :default => 0,     :null => false
    t.boolean   "is_shared",  :default => false, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "cms_layouts", ["parent_id", "position"], :name => "index_cms_layouts_on_parent_id_and_position"
  add_index "cms_layouts", ["site_id", "slug"], :name => "index_cms_layouts_on_site_id_and_slug", :unique => true

  create_table "cms_pages", :force => true do |t|
    t.integer   "site_id"
    t.integer   "layout_id"
    t.integer   "parent_id"
    t.integer   "target_page_id"
    t.string    "label"
    t.string    "slug"
    t.string    "full_path"
    t.text      "content"
    t.integer   "position",       :default => 0,     :null => false
    t.integer   "children_count", :default => 0,     :null => false
    t.boolean   "is_published",   :default => true,  :null => false
    t.boolean   "is_shared",      :default => false, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "cms_pages", ["parent_id", "position"], :name => "index_cms_pages_on_parent_id_and_position"
  add_index "cms_pages", ["site_id", "full_path"], :name => "index_cms_pages_on_site_id_and_full_path"

  create_table "cms_revisions", :force => true do |t|
    t.string    "record_type"
    t.integer   "record_id"
    t.text      "data"
    t.timestamp "created_at"
  end

  add_index "cms_revisions", ["record_type", "record_id", "created_at"], :name => "index_cms_revisions_on_record_type_and_record_id_and_created_at"

  create_table "cms_sites", :force => true do |t|
    t.string  "label"
    t.string  "hostname"
    t.string  "path"
    t.string  "locale",      :default => "en",  :null => false
    t.boolean "is_mirrored", :default => false, :null => false
  end

  add_index "cms_sites", ["hostname"], :name => "index_cms_sites_on_hostname"
  add_index "cms_sites", ["is_mirrored"], :name => "index_cms_sites_on_is_mirrored"

  create_table "cms_snippets", :force => true do |t|
    t.integer   "site_id"
    t.string    "label"
    t.string    "slug"
    t.text      "content"
    t.integer   "position",   :default => 0,     :null => false
    t.boolean   "is_shared",  :default => false, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "cms_snippets", ["site_id", "position"], :name => "index_cms_snippets_on_site_id_and_position"
  add_index "cms_snippets", ["site_id", "slug"], :name => "index_cms_snippets_on_site_id_and_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.text      "title"
    t.integer   "user_id"
    t.integer   "tracker_id"
    t.integer   "requirement_id"
    t.integer   "use_case_id"
    t.integer   "member_id"
    t.integer   "project_file_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string    "name"
    t.string    "reason"
    t.string    "email"
    t.text      "query"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "definitions", :force => true do |t|
    t.text      "term"
    t.text      "definition"
    t.integer   "project_id"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "delivery_periods", :force => true do |t|
    t.text      "title"
    t.integer   "project_id"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "help_requests", :force => true do |t|
    t.string    "sender_email"
    t.text      "email_content"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "helps", :force => true do |t|
    t.text      "faq"
    t.text      "result"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "tag"
    t.text      "keywords"
  end

  create_table "members", :force => true do |t|
    t.string    "first_name"
    t.string    "last_name"
    t.string    "email"
    t.string    "crypted_password"
    t.string    "password_salt"
    t.string    "persistence_token"
    t.string    "single_access_token"
    t.string    "perishable_token"
    t.integer   "login_count"
    t.integer   "failed_login_count"
    t.timestamp "last_request_at"
    t.timestamp "current_login_at"
    t.timestamp "last_login_at"
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.string    "newsletter"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "notify",              :default => false
    t.boolean   "active",              :default => false
    t.string    "privilige",           :default => "Read/Write"
    t.boolean   "dismiss_dashboard",   :default => false
  end

  create_table "messages", :force => true do |t|
    t.text      "title"
    t.text      "content"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "notification_messages", :force => true do |t|
    t.text      "subject"
    t.text      "message"
    t.integer   "user_id"
    t.integer   "member_id"
    t.integer   "project_id"
    t.boolean   "dismiss_flag", :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.boolean   "task_assigned",       :default => true
    t.boolean   "task_modified",       :default => true
    t.boolean   "req_approved",        :default => true
    t.boolean   "use_approved",        :default => false
    t.boolean   "req_review",          :default => false
    t.boolean   "use_review",          :default => false
    t.boolean   "use_created",         :default => false
    t.boolean   "req_created",         :default => false
    t.boolean   "def_created",         :default => false
    t.boolean   "file_uploaded",       :default => false
    t.boolean   "req_longer_approved", :default => true
    t.boolean   "use_longer_approved", :default => true
    t.integer   "user_id"
    t.integer   "member_id"
    t.integer   "project_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string    "plan_type"
    t.integer   "project_count"
    t.string    "storage"
    t.integer   "member_count"
    t.integer   "price"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "post_conditions", :force => true do |t|
    t.text      "title"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "pre_conditions", :force => true do |t|
    t.text      "title"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "project_files", :force => true do |t|
    t.string    "type1"
    t.text      "description"
    t.integer   "user_id"
    t.integer   "project_id"
    t.integer   "member_id"
    t.integer   "requirement_id"
    t.integer   "use_case_id"
    t.integer   "tracker_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "file_file_name"
    t.string    "file_content_type"
    t.integer   "file_file_size"
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
    t.string    "project_name"
    t.text      "description"
    t.text      "path"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "requirements", :force => true do |t|
    t.string    "name"
    t.string    "status"
    t.string    "category"
    t.string    "type1"
    t.integer   "project_id"
    t.string    "importance"
    t.string    "priority"
    t.string    "verification"
    t.string    "delivered"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
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
    t.text      "title"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "trackers", :force => true do |t|
    t.text      "title"
    t.string    "category"
    t.string    "assigned"
    t.integer   "assigned_subscriber_id"
    t.date      "due"
    t.boolean   "flag_tracker"
    t.integer   "member_id"
    t.integer   "user_id"
    t.integer   "project_id"
    t.integer   "requirement_id"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "trackers_use_cases", :id => false, :force => true do |t|
    t.integer "use_case_id"
    t.integer "tracker_id"
  end

  create_table "triggers", :force => true do |t|
    t.text      "title"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "use_case_details", :force => true do |t|
    t.text      "pre_conditions"
    t.text      "post_conditions"
    t.text      "success_conditions"
    t.text      "triggers"
    t.text      "actors"
    t.integer   "use_case_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "use_cases", :force => true do |t|
    t.integer   "project_id"
    t.string    "name"
    t.string    "status"
    t.string    "category"
    t.text      "goal"
    t.string    "delivered"
    t.string    "priority"
    t.string    "importance"
    t.integer   "user_id"
    t.integer   "member_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "user_plans", :force => true do |t|
    t.integer   "plan_id"
    t.integer   "user_id"
    t.integer   "project_count", :default => 0
    t.integer   "storage",       :default => 0
    t.integer   "member_count",  :default => 0
    t.text      "path"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "status"
  end

  create_table "users", :force => true do |t|
    t.string    "email"
    t.string    "crypted_password"
    t.string    "password_salt"
    t.string    "persistence_token"
    t.string    "single_access_token"
    t.string    "perishable_token"
    t.integer   "login_count"
    t.integer   "failed_login_count"
    t.timestamp "last_request_at"
    t.timestamp "current_login_at"
    t.timestamp "last_login_at"
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "active",              :default => false
    t.boolean   "dismiss_dashboard",   :default => false
    t.string    "privilige",           :default => "Admin"
  end

end
