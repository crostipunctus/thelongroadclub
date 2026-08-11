# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_11_000002) do
  create_table "bookmarks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "discussion_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["discussion_id"], name: "index_bookmarks_on_discussion_id"
    t.index ["user_id", "discussion_id"], name: "index_bookmarks_on_user_id_and_discussion_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "color", default: "green", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "discussions", force: :cascade do |t|
    t.text "body", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.boolean "featured", default: false, null: false
    t.datetime "last_posted_at", null: false
    t.boolean "pinned", default: false, null: false
    t.integer "replies_count", default: 0, null: false
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "views_count", default: 0, null: false
    t.index ["category_id"], name: "index_discussions_on_category_id"
    t.index ["pinned", "last_posted_at"], name: "index_discussions_on_pinned_and_last_posted_at"
    t.index ["slug"], name: "index_discussions_on_slug", unique: true
    t.index ["user_id"], name: "index_discussions_on_user_id"
  end

  create_table "event_rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "event_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["event_id", "user_id"], name: "index_event_rsvps_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_event_rsvps_on_event_id"
    t.index ["user_id"], name: "index_event_rsvps_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.datetime "ends_at"
    t.string "location", null: false
    t.boolean "published", default: false, null: false
    t.integer "rsvps_count", default: 0, null: false
    t.string "slug", null: false
    t.datetime "starts_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["published", "starts_at"], name: "index_events_on_published_and_starts_at"
    t.index ["slug"], name: "index_events_on_slug", unique: true
  end

  create_table "garage_features", force: :cascade do |t|
    t.string "car_make", null: false
    t.string "car_model", null: false
    t.integer "car_year", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.boolean "featured", default: false, null: false
    t.string "owner_name", null: false
    t.datetime "published_at"
    t.string "slug", null: false
    t.text "story", null: false
    t.text "summary", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["featured", "published_at"], name: "index_garage_features_on_featured_and_published_at"
    t.index ["slug"], name: "index_garage_features_on_slug", unique: true
    t.index ["user_id"], name: "index_garage_features_on_user_id"
  end

  create_table "guides", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "published_at"
    t.integer "read_time_minutes", default: 5, null: false
    t.string "section", null: false
    t.string "slug", null: false
    t.text "summary", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["published_at"], name: "index_guides_on_published_at"
    t.index ["slug"], name: "index_guides_on_slug", unique: true
    t.index ["user_id"], name: "index_guides_on_user_id"
  end

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "source", default: "homepage", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_newsletter_subscriptions_on_email", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "discussion_id", null: false
    t.datetime "edited_at"
    t.integer "parent_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["discussion_id", "created_at"], name: "index_posts_on_discussion_id_and_created_at"
    t.index ["discussion_id"], name: "index_posts_on_discussion_id"
    t.index ["parent_id"], name: "index_posts_on_parent_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_color", default: "green", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "location"
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.boolean "verified", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bookmarks", "discussions"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "discussions", "categories"
  add_foreign_key "discussions", "users"
  add_foreign_key "event_rsvps", "events"
  add_foreign_key "event_rsvps", "users"
  add_foreign_key "garage_features", "users"
  add_foreign_key "guides", "users"
  add_foreign_key "posts", "discussions"
  add_foreign_key "posts", "posts", column: "parent_id", on_delete: :cascade
  add_foreign_key "posts", "users"
end
