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

ActiveRecord::Schema[8.0].define(version: 2025_06_12_230746) do
  create_table "transactions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "counterparty_id"
    t.datetime "processed_at", null: false
    t.integer "transaction_type", default: 0, null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value_cents", default: 0, null: false
    t.date "scheduled_visit_date"
    t.index ["counterparty_id"], name: "index_transactions_on_counterparty_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "acc_number", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "user_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance_cents", default: 0, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.index ["acc_number"], name: "index_users_on_acc_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "transactions", "users"
  add_foreign_key "transactions", "users", column: "counterparty_id"
end
