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

ActiveRecord::Schema[7.0].define(version: 2024_07_28_175328) do
  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "cart_items_customizable_options", id: false, force: :cascade do |t|
    t.integer "cart_item_id", null: false
    t.integer "customizable_option_id", null: false
    t.index ["cart_item_id", "customizable_option_id"], name: "uniq_cart_item_id_customizable_option_id", unique: true
    t.index ["customizable_option_id", "cart_item_id"], name: "index_customizable_option_id_cart_item_id"
  end

  create_table "carts", force: :cascade do |t|
    t.float "total", default: 0.0
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customizable_option_price_by_groups", force: :cascade do |t|
    t.integer "customizable_option_id", null: false
    t.integer "pricing_group_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customizable_option_id", "pricing_group_id"], name: "uniq_customizable_option_id_pricing_group_id", unique: true
    t.index ["customizable_option_id"], name: "idx_customizable_option_id"
    t.index ["pricing_group_id"], name: "idx_pricing_group_id"
  end

  create_table "customizable_options", force: :cascade do |t|
    t.string "name"
    t.integer "customizable_id", null: false
    t.float "price", default: 0.0
    t.boolean "stock", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customizable_id"], name: "index_customizable_options_on_customizable_id"
  end

  create_table "customizable_options_pricing_groups", id: false, force: :cascade do |t|
    t.integer "pricing_group_id", null: false
    t.integer "customizable_option_id", null: false
    t.index ["customizable_option_id", "pricing_group_id"], name: "index_customizable_option_id_pricing_group_id"
    t.index ["pricing_group_id", "customizable_option_id"], name: "uniq_pricing_group_id_customizable_option_id", unique: true
  end

  create_table "customizable_options_products", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "customizable_option_id", null: false
    t.index ["customizable_option_id", "product_id"], name: "index_customizable_option_id_product_id"
    t.index ["product_id", "customizable_option_id"], name: "uniq_product_id_customizable_option_id", unique: true
  end

  create_table "customizables", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pricing_groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prohibitions", force: :cascade do |t|
    t.integer "customizable_option_id"
    t.integer "prohibited_customizable_option_id"
    t.index ["customizable_option_id", "prohibited_customizable_option_id"], name: "index_prohibitions_on_customizable_and_prohibited", unique: true
    t.index ["prohibited_customizable_option_id", "customizable_option_id"], name: "index_prohibitions_on_prohibited_and_customizable", unique: true
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "customers"
  add_foreign_key "customizable_option_price_by_groups", "customizable_options"
  add_foreign_key "customizable_option_price_by_groups", "pricing_groups"
  add_foreign_key "customizable_options", "customizables"
end
