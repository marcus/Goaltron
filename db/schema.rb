# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 46) do

  create_table "assigned_sections", :force => true do |t|
    t.integer "article_id"
    t.integer "section_id"
    t.integer "position",   :default => 1
  end

  create_table "contents", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.text     "excerpt"
    t.string   "permalink"
    t.boolean  "public"
    t.boolean  "approved"
    t.boolean  "comment_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "author_id"
    t.string   "type"
    t.integer  "article_id"
  end

  create_table "daily_day_entries", :force => true do |t|
    t.integer "user_id"
    t.date    "day"
    t.integer "self_score"
  end

  create_table "daily_goal_entries", :force => true do |t|
    t.integer "daily_goal_id"
    t.boolean "completed",          :default => false
    t.integer "daily_day_entry_id"
  end

  create_table "daily_goals", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "user_id"
    t.boolean "active",      :default => true
  end

  create_table "goal_entries", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.integer  "goal_id"
  end

  create_table "goal_steps", :force => true do |t|
    t.integer  "position"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "completed_at"
    t.integer  "goal_id"
  end

  create_table "goals", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "completed_at"
    t.integer  "user_id"
    t.text     "information"
    t.integer  "position"
  end

  create_table "journal_entries", :force => true do |t|
    t.integer "user_id"
    t.date    "entry_date"
    t.text    "good"
    t.text    "bad"
    t.boolean "public",     :default => false
    t.boolean "draft",      :default => false
  end

  create_table "sections", :force => true do |t|
    t.string "name"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tag_id"
    t.datetime "created_on"
  end

  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "reference_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "time_zone",                               :default => "EST"
    t.boolean  "approved"
  end

end
