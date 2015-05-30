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

ActiveRecord::Schema.define(version: 20150529054255) do

  create_table "asso_relations", force: :cascade do |t|
    t.integer  "factory_id"
    t.integer  "asso_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assos", force: :cascade do |t|
    t.string   "name"
    t.integer  "factory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factory_logs", force: :cascade do |t|
    t.string   "name"
    t.text     "traits"
    t.text     "assos"
    t.float    "time"
    t.integer  "parent_id"
    t.integer  "factory_id"
    t.float    "exectuaion_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "trait_relations", force: :cascade do |t|
    t.integer  "factory_id"
    t.integer  "trait_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traits", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
