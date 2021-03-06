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

ActiveRecord::Schema.define(version: 2019_05_10_170559) do

  create_table "posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "head_id"
    t.string "title"
    t.string "name"
    t.datetime "post_at"
    t.string "kid"
    t.string "number"
    t.string "picture"
    t.integer "hidden_body_count"
    t.text "content"
    t.string "head_number"
    t.index ["head_id"], name: "index_posts_on_head_id"
    t.index ["head_number"], name: "index_posts_on_head_number"
    t.index ["kid"], name: "index_posts_on_kid"
    t.index ["number"], name: "index_posts_on_number"
    t.index ["post_at"], name: "index_posts_on_post_at"
  end

end
