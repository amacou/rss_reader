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
    t.string   "title"
    t.string   "author"
    t.string   "link"
    t.text     "description"
    t.datetime "published_at"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "xml_url"
    t.string   "feed_type"
    t.datetime "last_checked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "etag"
    t.integer  "error_count",      default: 0
    t.datetime "last_modified_at"
    t.integer  "skip_count",       default: 0
    t.index ["xml_url"], name: "index_feeds_on_xml_url"
  end

  create_table "folders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.integer  "folder_id"
    t.string   "xml_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["feed_id"], name: "index_subscriptions_on_feed_id"
    t.index ["folder_id"], name: "index_subscriptions_on_folder_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "unread_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.integer  "subscription_id"
    t.boolean  "readed",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "weight"
    t.index ["entry_id"], name: "index_unread_entries_on_entry_id"
    t.index ["subscription_id"], name: "index_unread_entries_on_subscription_id"
    t.index ["user_id"], name: "index_unread_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_type",  default: "DESC"
  end

end
