# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_27_144606) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "password_hash"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.index ["name"], name: "index_admins_on_name"
  end

  create_table "arrangers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "base_order_count", default: 0
    t.string "name"
    t.string "phone_number"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "orders_count", default: 0
    t.index ["orders_count"], name: "index_arrangers_on_orders_count"
  end

  create_table "course_teachers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "course_id"
    t.integer "teacher_id"
    t.string "name"
    t.text "introduce"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_teachers_on_course_id"
    t.index ["teacher_id"], name: "index_course_teachers_on_teacher_id"
  end

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "city_id"
    t.string "city_name"
    t.string "start_date"
    t.string "end_date"
    t.text "description"
    t.string "front_image"
    t.string "detailed_image"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "external_ids", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "prefix", limit: 5
    t.string "date"
    t.integer "number", default: 0
    t.index ["prefix", "date"], name: "index_external_ids_on_prefix_and_date"
  end

  create_table "order_arranger_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "arranger_id"
    t.string "order_type", limit: 20
    t.float "amount", default: 0.0
    t.string "item_type", limit: 20
    t.index ["arranger_id", "order_type"], name: "index_order_arranger_assignments_on_arranger_id_and_order_type"
    t.index ["order_id"], name: "index_order_arranger_assignments_on_order_id"
  end

  create_table "order_payment_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "payment_method_id"
    t.string "payment_method_name"
    t.float "cost"
    t.boolean "active"
    t.datetime "timestamp"
    t.string "out_trade_no"
    t.string "transaction_id"
    t.index ["order_id"], name: "index_order_payment_records_on_order_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "admin_id"
    t.string "city_name"
    t.string "start_date"
    t.string "end_date"
    t.string "status"
    t.string "order_type", limit: 20
    t.string "customer_name"
    t.string "customer_phone_number"
    t.string "address_province"
    t.string "address_city"
    t.string "location_title"
    t.string "location_address"
    t.string "location_details"
    t.string "referral_name"
    t.string "referral_phone_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "external_id", limit: 20
    t.text "notes"
    t.text "service_notes"
    t.index ["external_id"], name: "index_orders_on_external_id"
    t.index ["order_type"], name: "index_orders_on_order_type"
    t.index ["start_date"], name: "index_orders_on_start_date"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type"
    t.float "price"
    t.string "title"
    t.string "city_name"
    t.string "start_date"
    t.string "end_date"
    t.text "description"
    t.string "front_image"
    t.string "detailed_image"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type"], name: "index_products_on_type"
  end

  create_table "purchased_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_purchased_items_on_order_id"
  end

  create_table "role_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "role_id"
    t.index ["admin_id", "role_id"], name: "index_role_assignments_on_admin_id_and_role_id"
    t.index ["admin_id"], name: "index_role_assignments_on_admin_id"
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "students", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.integer "order_id"
    t.string "city_name"
    t.string "careers"
    t.string "career_plan"
    t.text "notes"
    t.text "feedback"
    t.text "review"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_students_on_course_id"
    t.index ["order_id"], name: "index_students_on_order_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "teachers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "introduce"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "phone_number", limit: 20
    t.string "name"
    t.integer "sex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phone_number"], name: "index_users_on_phone_number"
  end

end
