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

ActiveRecord::Schema.define(:version => 20101020184155) do

  create_table "application_files", :force => true do |t|
    t.string   "name"
    t.boolean  "is_executable"
    t.binary   "bytes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_files_subapps", :id => false, :force => true do |t|
    t.integer "applications_file_id", :null => false
    t.integer "subapp_id",            :null => false
  end

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
  end

end
