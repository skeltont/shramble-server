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

ActiveRecord::Schema[7.0].define(version: 2022_03_09_065147) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "contestants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_contestants_on_room_id"
  end

  create_table "matches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "room_id"
    t.decimal "wager", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "active", null: false
    t.index ["room_id"], name: "index_matches_on_room_id"
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "owner", default: false
    t.index ["room_id"], name: "index_players_on_room_id"
  end

  create_table "results", force: :cascade do |t|
    t.uuid "player_id"
    t.uuid "contestant_id"
    t.uuid "match_id"
    t.boolean "win", default: false
    t.boolean "pass", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contestant_id"], name: "index_results_on_contestant_id"
    t.index ["match_id"], name: "index_results_on_match_id"
    t.index ["player_id"], name: "index_results_on_player_id"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "room_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "pending", null: false
  end

  add_foreign_key "contestants", "rooms"
  add_foreign_key "matches", "rooms"
  add_foreign_key "players", "rooms"
  add_foreign_key "results", "contestants"
  add_foreign_key "results", "matches"
  add_foreign_key "results", "players"
end
