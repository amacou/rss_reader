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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130429081743) do

  create_table "entries", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "author",       limit: 255
    t.string   "link",         limit: 255
    t.text     "description",  limit: 65535
    t.datetime "published_at"
    t.integer  "feed_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "url",              limit: 255
    t.string   "xml_url",          limit: 255
    t.string   "feed_type",        limit: 255
    t.datetime "last_checked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "etag",             limit: 255
    t.integer  "error_count",      limit: 4,   default: 0
    t.datetime "last_modified_at"
    t.integer  "skip_count",       limit: 4,   default: 0
  end

  add_index "feeds", ["xml_url"], name: "index_feeds_on_xml_url", using: :btree

  create_table "folders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["user_id"], name: "index_folders_on_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "feed_id",    limit: 4
    t.integer  "folder_id",  limit: 4
    t.string   "xml_url",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["feed_id"], name: "index_subscriptions_on_feed_id", using: :btree
  add_index "subscriptions", ["folder_id"], name: "index_subscriptions_on_folder_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "unread_entries", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "entry_id",        limit: 4
    t.integer  "subscription_id", limit: 4
    t.boolean  "readed",                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "weight",          limit: 255
  end

  add_index "unread_entries", ["entry_id"], name: "index_unread_entries_on_entry_id", using: :btree
  add_index "unread_entries", ["subscription_id"], name: "index_unread_entries_on_subscription_id", using: :btree
  add_index "unread_entries", ["user_id"], name: "index_unread_entries_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_type",  limit: 255, default: "DESC"
  end

end
