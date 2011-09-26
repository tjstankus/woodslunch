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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110924052347) do

  create_table "account_requests", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "state"
    t.string   "activation_token"
    t.datetime "approved_at"
    t.datetime "declined_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "account_transactions", :force => true do |t|
    t.integer  "account_id"
    t.string   "type"
    t.decimal  "amount",     :precision => 5, :scale => 2, :default => 0.0
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.decimal  "balance",    :precision => 5, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_menu_items", :force => true do |t|
    t.integer  "day_of_week_id"
    t.integer  "menu_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days_of_week", :force => true do |t|
    t.string "name"
  end

  add_index "days_of_week", ["name"], :name => "index_days_of_week_on_name", :unique => true

  create_table "days_off", :force => true do |t|
    t.date     "starts_on"
    t.date     "ends_on"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "days_off", ["ends_on"], :name => "index_days_off_on_ends_on", :unique => true
  add_index "days_off", ["starts_on"], :name => "index_days_off_on_starts_on", :unique => true

  create_table "menu_items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",       :precision => 5, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  add_index "menu_items", ["name"], :name => "index_menu_items_on_name", :unique => true

  create_table "ordered_menu_items", :force => true do |t|
    t.integer  "menu_item_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.decimal  "total",        :precision => 5, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.date     "served_on"
    t.integer  "student_id"
    t.integer  "user_id"
    t.string   "type"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requested_students", :force => true do |t|
    t.integer "account_request_id"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "grade"
  end

  create_table "students", :force => true do |t|
    t.integer  "account_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["account_id"], :name => "index_students_on_account_id"
  add_index "students", ["first_name"], :name => "index_students_on_first_name"
  add_index "students", ["last_name"], :name => "index_students_on_last_name"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask"
    t.integer  "account_id"
    t.string   "preferred_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
