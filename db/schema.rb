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

ActiveRecord::Schema[7.1].define(version: 2025_02_14_111006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doctors", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_doctors_on_user_id"
  end

  create_table "dosages", force: :cascade do |t|
    t.string "amount", null: false
    t.string "frequency", null: false
    t.string "default_duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_dosages", force: :cascade do |t|
    t.bigint "medication_id", null: false
    t.bigint "dosage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dosage_id"], name: "index_medication_dosages_on_dosage_id"
    t.index ["medication_id", "dosage_id"], name: "index_medication_dosages_on_medication_id_and_dosage_id", unique: true
    t.index ["medication_id"], name: "index_medication_dosages_on_medication_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_medications_on_name", unique: true
  end

  create_table "patients", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.string "gender", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "prescription_items", force: :cascade do |t|
    t.bigint "prescription_id", null: false
    t.bigint "medication_id", null: false
    t.bigint "dosage_id", null: false
    t.integer "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dosage_id"], name: "index_prescription_items_on_dosage_id"
    t.index ["medication_id"], name: "index_prescription_items_on_medication_id"
    t.index ["prescription_id", "medication_id"], name: "index_prescription_items_on_prescription_id_and_medication_id", unique: true
    t.index ["prescription_id"], name: "index_prescription_items_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "doctor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_prescriptions_on_doctor_id"
    t.index ["patient_id"], name: "index_prescriptions_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "doctors", "users"
  add_foreign_key "medication_dosages", "dosages"
  add_foreign_key "medication_dosages", "medications"
  add_foreign_key "patients", "users"
  add_foreign_key "prescription_items", "dosages"
  add_foreign_key "prescription_items", "medications"
  add_foreign_key "prescription_items", "prescriptions"
  add_foreign_key "prescriptions", "doctors"
  add_foreign_key "prescriptions", "patients"
end
