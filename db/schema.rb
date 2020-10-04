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

ActiveRecord::Schema.define(version: 2020_10_02_112713) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ad_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "ad_type"
    t.string "url"
    t.string "mobile_image"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pc_image"
    t.index ["ad_type", "active"], name: "index_ad_images_on_ad_type_and_active"
  end

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "recipient_name"
    t.string "recipient_phone_number"
    t.string "location_title"
    t.string "location_address"
    t.string "location_details"
    t.decimal "gaode_lng", precision: 11, scale: 8
    t.decimal "gaode_lat", precision: 11, scale: 8
    t.string "address_province"
    t.string "address_city"
    t.string "address_district"
    t.boolean "is_default", default: false
    t.integer "sex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "is_default"], name: "index_addresses_on_user_id_and_is_default"
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "password_hash"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.index ["name"], name: "index_admins_on_name"
  end

  create_table "applies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "admin_id"
    t.string "item_type"
    t.string "status", default: "unconfirmed"
    t.float "cost"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_type", "status"], name: "index_applies_on_item_type_and_status"
    t.index ["user_id"], name: "index_applies_on_user_id"
  end

  create_table "apply_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "apply_id"
    t.string "item_type"
    t.integer "item_id"
    t.string "status", default: "unconfirmed"
    t.index ["apply_id"], name: "index_apply_items_on_apply_id"
    t.index ["item_type"], name: "index_apply_items_on_item_type_and_item_type"
    t.index ["status"], name: "index_apply_items_on_status"
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

  create_table "cases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "description"
    t.string "mobile_image"
    t.string "pc_image"
    t.boolean "active"
    t.integer "position", default: 999
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ckeditor_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "course_city_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "course_id"
    t.string "city_name"
    t.string "date_info"
    t.string "address"
    t.boolean "active"
    t.integer "position", default: 999
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_city_infos_on_course_id"
  end

  create_table "course_extends", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "course_id"
    t.string "address"
    t.decimal "gaode_lng", precision: 11, scale: 8
    t.decimal "gaode_lat", precision: 11, scale: 8
    t.boolean "has_student_zhekou", default: false
    t.text "city_and_date"
    t.boolean "show_city_list", default: false
    t.text "city_and_address"
    t.index ["course_id"], name: "index_course_extends_on_course_id"
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

  create_table "delivery_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.string "status", default: "new"
    t.string "express_name"
    t.string "express_no", limit: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["express_no"], name: "index_delivery_orders_on_express_no"
    t.index ["order_id"], name: "index_delivery_orders_on_order_id"
  end

  create_table "external_ids", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "prefix", limit: 5
    t.string "date"
    t.integer "number", default: 0
    t.index ["prefix", "date"], name: "index_external_ids_on_prefix_and_date"
  end

  create_table "franchise_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "franchise_id"
    t.string "mobile_image"
    t.integer "position", default: 999
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["franchise_id", "active"], name: "index_franchise_images_on_franchise_id_and_active"
  end

  create_table "franchises", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "user_name"
    t.string "phone_number"
    t.string "email"
    t.string "front_image"
    t.string "detailed_image"
    t.string "status", default: "unconfirmed"
    t.string "city_name"
    t.text "desc"
    t.boolean "active"
    t.integer "position", default: 999
    t.string "applet_form_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "apply_msg"
    t.text "apply_notes"
    t.index ["user_id", "active"], name: "index_franchises_on_user_id_and_active"
  end

  create_table "introduces", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "item_type"
    t.string "mobile_image"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tag"
    t.string "pc_image"
    t.string "url"
    t.integer "position", default: 999
    t.index ["item_type", "active"], name: "index_introduces_on_item_type_and_active"
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
    t.integer "admin_id"
    t.string "batch_no", limit: 20
    t.text "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "refund_id"
    t.integer "operate_user_id"
    t.index ["batch_no"], name: "index_order_payment_records_on_batch_no"
    t.index ["order_id"], name: "index_order_payment_records_on_order_id"
    t.index ["transaction_id"], name: "index_order_payment_records_on_transaction_id"
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
    t.integer "sex"
    t.string "wx_open_id", limit: 50
    t.string "purchase_source", limit: 20
    t.string "recipient_name"
    t.string "recipient_phone_number"
    t.string "address_district"
    t.string "applet_form_id"
    t.float "zhekou", default: 1.0
    t.string "organizer_phone_number"
    t.string "organizer_name"
    t.index ["external_id"], name: "index_orders_on_external_id"
    t.index ["order_type"], name: "index_orders_on_order_type"
    t.index ["purchase_source"], name: "index_orders_on_purchase_source"
    t.index ["start_date"], name: "index_orders_on_start_date"
  end

  create_table "pages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url", limit: 50
    t.string "title"
    t.text "content"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url"], name: "index_pages_on_url"
  end

  create_table "percent_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_type"
    t.integer "item_id"
    t.text "extend"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_type", "item_id"], name: "index_percent_infos_on_item_type_and_item_id"
  end

  create_table "product_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "type"
    t.string "mobile_image"
    t.integer "position", default: 999
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_sets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "front_image"
    t.string "detailed_image"
    t.integer "position", default: 999
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "position", default: 999
    t.string "count_string"
    t.boolean "create_tenpay", default: false
    t.integer "min_count", default: 1
    t.float "earnest_price"
    t.integer "max_count"
    t.integer "advance_days", default: 1
    t.string "pc_front_image"
    t.string "pc_detailed_image"
    t.text "web_content"
    t.string "sub_title"
    t.boolean "show_city_list"
    t.float "service_percent", default: 1.0
    t.integer "product_set_id"
    t.index ["product_set_id"], name: "index_products_on_product_set_id"
    t.index ["type"], name: "index_products_on_type"
  end

  create_table "purchased_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "delivery_order_id"
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
    t.string "phone_number", limit: 20
    t.string "name"
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
    t.string "mobile_image"
    t.string "tag"
    t.string "web_tag"
    t.integer "position", default: 999
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "phone_number", limit: 20
    t.string "name"
    t.integer "sex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wx_ma_id", limit: 50
    t.string "wx_union_id", limit: 50
    t.string "source", limit: 50
    t.string "profession"
    t.string "address_province"
    t.string "address_city"
    t.string "address_district"
    t.string "avatar"
    t.float "zhekou", default: 1.0
    t.integer "status", default: 1
    t.boolean "show_achievement", default: false
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["wx_ma_id"], name: "index_users_on_wx_ma_id"
    t.index ["wx_union_id"], name: "index_users_on_wx_union_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
