# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101211210439) do

  create_table "application_files", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.boolean  "is_executable"
    t.binary   "bytes",         :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_files", ["name"], :name => "index_application_files_on_name"

  create_table "application_files_subapps", :id => false, :force => true do |t|
    t.integer "application_file_id", :null => false
    t.integer "subapp_id",           :null => false
  end

  add_index "application_files_subapps", ["subapp_id"], :name => "index_application_files_subapps_on_subapp_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "input_files", :force => true do |t|
    t.string   "name"
    t.binary   "bytes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_files_launches", :id => false, :force => true do |t|
    t.integer "input_file_id", :null => false
    t.integer "launch_id",     :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "address"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "launch_id"
    t.string   "command_line"
    t.string   "sequence_args"
  end

  add_index "jobs", ["launch_id"], :name => "index_jobs_on_launch_id"
  add_index "jobs", ["state"], :name => "index_jobs_on_state"

  create_table "launches", :force => true do |t|
    t.string   "name"
    t.text     "settings"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.integer  "subapp_id"
    t.integer  "person_id"
    t.integer  "parent_id"
    t.boolean  "single"
    t.boolean  "refreshing"
  end

  add_index "launches", ["name"], :name => "index_launches_on_name"
  add_index "launches", ["parent_id"], :name => "index_launches_on_parent_id"
  add_index "launches", ["person_id"], :name => "index_launches_on_person_id"
  add_index "launches", ["state"], :name => "index_launches_on_state"
  add_index "launches", ["subapp_id"], :name => "index_launches_on_subapp_id"

  create_table "people", :force => true do |t|
    t.string   "nick"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles"
    t.string   "login",               :null => false
    t.string   "email",               :null => false
    t.string   "crypted_password",    :null => false
    t.string   "password_salt",       :null => false
    t.string   "persistence_token",   :null => false
    t.string   "single_access_token", :null => false
    t.string   "perishable_token",    :null => false
  end

  create_table "preferences", :force => true do |t|
    t.integer  "person_id"
    t.string   "prefs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subapps", :force => true do |t|
    t.string   "name"
    t.text     "input_partial"
    t.text     "settings"
    t.text     "executable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tech_name"
    t.text     "jsdl"
    t.string   "state"
    t.integer  "person_id"
    t.integer  "parent_id"
  end

  add_index "subapps", ["name"], :name => "index_subapps_on_name"
  add_index "subapps", ["parent_id"], :name => "index_subapps_on_parent_id"
  add_index "subapps", ["person_id"], :name => "index_subapps_on_person_id"
  add_index "subapps", ["state"], :name => "index_subapps_on_state"

end
