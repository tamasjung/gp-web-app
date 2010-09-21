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

ActiveRecord::Schema.define(:version => 20100921205425) do

  create_table "application_files", :force => true do |t|
    t.string   "name"
    t.boolean  "is_executable"
    t.binary   "bytes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_files", :force => true do |t|
    t.string   "name"
    t.binary   "bytes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "address"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "launch_id"
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
  end

  create_table "people", :force => true do |t|
    t.string   "nick"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles"
  end

  create_table "people_launches", :force => true do |t|
  end

  create_table "people_subapps", :force => true do |t|
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
