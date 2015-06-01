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

ActiveRecord::Schema.define(version: 20150530075825) do

  create_table "asso_relations", force: :cascade do |t|
    t.integer "factory_id"
    t.integer "asso_id"
  end

  create_table "assos", force: :cascade do |t|
    t.string  "name"
    t.integer "factory_id"
  end

  create_table "factories", force: :cascade do |t|
    t.string "name"
  end

  create_table "factory_logs", force: :cascade do |t|
    t.integer "factory_id"
    t.float   "execution_time"
  end

  create_table "trait_relations", force: :cascade do |t|
    t.integer "factory_id"
    t.integer "trait_id"
  end

  create_table "traits", force: :cascade do |t|
    t.string "name"
  end

end
