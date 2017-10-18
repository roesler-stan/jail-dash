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

ActiveRecord::Schema.define(version: 20171018215357) do

  create_table "agency_populations", force: :cascade do |t|
    t.string "agency_id", null: false
    t.integer "population"
    t.index ["agency_id"], name: "index_agency_populations_on_agency_id", unique: true
  end

  create_table "arrests", force: :cascade do |t|
    t.string "slc_id", null: false
    t.string "extdesc"
    t.index ["slc_id"], name: "index_arrests_on_slc_id", unique: true
  end

  create_table "billing_communities", force: :cascade do |t|
    t.bigint "id_guid", null: false
    t.string "extdesc"
    t.index ["id_guid"], name: "index_billing_communities_on_id_guid", unique: true
  end

  create_table "bond_masters", force: :cascade do |t|
    t.bigint "bondid", null: false
    t.bigint "sysid"
    t.bigint "case_pk"
    t.integer "original_bond_amt"
    t.string "type_id"
    t.index ["bondid"], name: "index_bond_masters_on_bondid", unique: true
    t.index ["case_pk"], name: "index_bond_masters_on_case_pk"
    t.index ["sysid"], name: "index_bond_masters_on_sysid"
    t.index ["type_id"], name: "index_bond_masters_on_type_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.string "arrest"
    t.datetime "comdate"
    t.bigint "sysid", null: false
    t.datetime "reldate"
    t.string "jlocat"
    t.index ["arrest"], name: "index_bookings_on_arrest"
    t.index ["comdate"], name: "index_bookings_on_comdate"
    t.index ["reldate"], name: "index_bookings_on_reldate"
    t.index ["sysid"], name: "index_bookings_on_sysid", unique: true
  end

  create_table "case_charge_sentences", force: :cascade do |t|
    t.integer "max_days"
    t.bigint "charge_pk"
    t.index ["charge_pk"], name: "index_case_charge_sentences_on_charge_pk"
  end

  create_table "case_charges", force: :cascade do |t|
    t.bigint "charge_pk", null: false
    t.bigint "case_pk"
    t.bigint "sysid"
    t.string "reason_for_discharge"
    t.string "disposition"
    t.datetime "disposition_date"
    t.index ["case_pk"], name: "index_case_charges_on_case_pk"
    t.index ["charge_pk"], name: "index_case_charges_on_charge_pk", unique: true
    t.index ["sysid"], name: "index_case_charges_on_sysid"
  end

  create_table "case_masters", force: :cascade do |t|
    t.bigint "case_pk", null: false
    t.string "jurisdiction_code"
    t.string "judge"
    t.bigint "billing_community"
    t.bigint "sysid"
    t.index ["billing_community"], name: "index_case_masters_on_billing_community"
    t.index ["case_pk"], name: "index_case_masters_on_case_pk", unique: true
    t.index ["judge"], name: "index_case_masters_on_judge"
    t.index ["jurisdiction_code"], name: "index_case_masters_on_jurisdiction_code"
    t.index ["sysid"], name: "index_case_masters_on_sysid"
  end

  create_table "hearing_court_names", force: :cascade do |t|
    t.string "slc_id", null: false
    t.string "extdesc"
    t.index ["slc_id"], name: "index_hearing_court_names_on_slc_id"
  end

  create_table "judges", force: :cascade do |t|
    t.string "slc_id", null: false
    t.string "extdesc"
    t.index ["slc_id"], name: "index_judges_on_slc_id"
  end

end
