# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121213141952) do

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          :default => 0, :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "partner_id",       :default => 1
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "iphoto_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "partner_id", :default => 1
  end

  create_table "iphotos", :force => true do |t|
    t.string   "i_id"
    t.string   "url"
    t.string   "username"
    t.integer  "tag_id"
    t.boolean  "status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "public_id"
    t.integer  "partner_id", :default => 1
  end

  add_index "iphotos", ["i_id"], :name => "index_iphotos_on_i_id", :unique => true
  add_index "iphotos", ["partner_id"], :name => "index_iphotos_on_partner_id"
  add_index "iphotos", ["username"], :name => "index_iphotos_on_username"

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "setups", :force => true do |t|
    t.string   "key_name"
    t.string   "key_val"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "max_photo_id"
    t.integer  "partner_id",   :default => 1
  end

  add_index "tags", ["partner_id"], :name => "index_tags_on_partner_id"

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.string   "email"
    t.string   "image"
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "full_name"
    t.boolean  "is_admin"
    t.integer  "partner_id", :default => 1
    t.string   "website"
    t.text     "bio"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["partner_id"], :name => "index_users_on_partner_id"

end
