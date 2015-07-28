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

ActiveRecord::Schema.define(version: 20150629184325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "subscription_id"
    t.string   "country"
    t.datetime "flagged_invalid_at"
  end

  add_index "addresses", ["flagged_invalid_at"], name: "index_addresses_on_flagged_invalid_at", using: :btree
  add_index "addresses", ["subscription_id"], name: "index_addresses_on_subscription_id", using: :btree
  add_index "addresses", ["type"], name: "index_addresses_on_type", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "affiliates", force: :cascade do |t|
    t.string  "name"
    t.string  "redirect_url"
    t.boolean "active"
  end

  create_table "campaign_conversions", force: :cascade do |t|
    t.string   "utm_source"
    t.string   "utm_campaign"
    t.string   "utm_medium"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_conversions", ["user_id"], name: "index_campaign_conversions_on_user_id", using: :btree

  create_table "chargify_customers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chargify_customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "braintree"
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "chargify_coupon_code"
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chargify_subscription_id"
    t.string   "coupon_code"
    t.integer  "subscription_id"
    t.string   "recurly_subscription_id"
  end

  add_index "checkouts", ["plan_id"], name: "index_checkouts_on_plan_id", using: :btree
  add_index "checkouts", ["recurly_subscription_id"], name: "index_checkouts_on_recurly_subscription_id", using: :btree
  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "usage_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",       default: "Active"
    t.datetime "archived_at"
    t.integer  "promotion_id"
  end

  add_index "coupons", ["promotion_id"], name: "index_coupons_on_promotion_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "friendbuy_conversion_events", force: :cascade do |t|
    t.string   "possible_self_referral"
    t.string   "share_id"
    t.string   "new_order_ip_address"
    t.string   "network"
    t.string   "share_campaign_id"
    t.string   "original_order_id"
    t.integer  "new_order_id"
    t.string   "email"
    t.string   "share_campaign_name"
    t.string   "original_order_customer_id"
    t.integer  "share_customer_id"
    t.integer  "new_order_customer_id"
    t.string   "share_ip_address"
    t.integer  "conversion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "personal_url_customer_email"
    t.string   "reward_amount"
    t.string   "new_order_customer_email"
  end

  add_index "friendbuy_conversion_events", ["conversion_id"], name: "index_friendbuy_conversion_events_on_conversion_id", unique: true, using: :btree
  add_index "friendbuy_conversion_events", ["email"], name: "index_friendbuy_conversion_events_on_email", using: :btree
  add_index "friendbuy_conversion_events", ["share_customer_id"], name: "index_friendbuy_conversion_events_on_share_customer_id", using: :btree

  create_table "inventory_units", force: :cascade do |t|
    t.boolean  "in_stock",        default: false
    t.integer  "variant_id"
    t.integer  "total_committed", default: 0
    t.integer  "total_available", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "looter_info_surveys", force: :cascade do |t|
    t.string   "looter_name"
    t.string   "email"
    t.string   "shirt_size"
    t.boolean  "used",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders_csvs", force: :cascade do |t|
    t.string   "url"
    t.string   "status",     default: "pending"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "period",                default: 1
    t.float    "shipping_and_handling", default: 6.0
    t.string   "savings_copy",          default: "Cancel Anytime"
    t.integer  "product_id"
    t.string   "country"
    t.string   "title"
  end

  add_index "plans", ["product_id"], name: "index_plans_on_product_id", using: :btree

  create_table "plans_promotions", id: false, force: :cascade do |t|
    t.integer "plan_id"
    t.integer "promotion_id"
  end

  add_index "plans_promotions", ["plan_id", "promotion_id"], name: "index_plans_promotions_on_plan_id_and_promotion_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "brand"
    t.integer  "max_inventory_count"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "available_on"
    t.text     "description"
    t.string   "sku"
  end

  create_table "promo_conversions", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "promotion_id"
    t.string   "product_type"
    t.decimal  "product_initial_cost",    precision: 8, scale: 2
    t.decimal  "product_discounted_cost", precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coupon_id"
  end

  add_index "promo_conversions", ["coupon_id"], name: "index_promo_conversions_on_coupon_id", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.date     "starts_at"
    t.date     "ends_at"
    t.text     "description"
    t.string   "name"
    t.boolean  "one_time_use",                                         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "adjustment_amount",            precision: 8, scale: 2
    t.string   "adjustment_type"
    t.integer  "conversion_limit"
    t.string   "trigger_event"
    t.string   "coupon_prefix",     limit: 50
  end

  add_index "promotions", ["coupon_prefix"], name: "index_promotions_on_coupon_prefix", unique: true, using: :btree

  create_table "recurly_accounts", force: :cascade do |t|
    t.string   "recurly_account_id"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "recurly_accounts", ["user_id"], name: "index_recurly_accounts_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "store_credits", force: :cascade do |t|
    t.integer  "referrer_user_id"
    t.decimal  "amount",                  precision: 8, scale: 2, default: 0.0, null: false
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "referrer_user_email"
    t.integer  "referred_user_id"
    t.string   "referred_user_email"
    t.string   "status"
    t.integer  "friendbuy_conversion_id"
  end

  add_index "store_credits", ["friendbuy_conversion_id"], name: "index_store_credits_on_friendbuy_conversion_id", unique: true, using: :btree
  add_index "store_credits", ["referred_user_id"], name: "index_store_credits_on_referred_user_id", using: :btree
  add_index "store_credits", ["referrer_user_id"], name: "index_store_credits_on_referrer_user_id", using: :btree

  create_table "subscription_backfiller_jobs", force: :cascade do |t|
    t.string   "account_code"
    t.string   "plan_code"
    t.datetime "starts_at"
    t.datetime "next_assessment_at"
    t.decimal  "balance",            precision: 8, scale: 2
    t.string   "status"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "subscription_id"
  end

  add_index "subscription_backfiller_jobs", ["status"], name: "index_subscription_backfiller_jobs_on_status", using: :btree
  add_index "subscription_backfiller_jobs", ["subscription_id"], name: "index_subscription_backfiller_jobs_on_subscription_id", using: :btree

  create_table "subscription_creation_errors", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.integer  "chargify_subscription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription_periods", force: :cascade do |t|
    t.integer  "subscription_id"
    t.string   "status"
    t.integer  "term_length"
    t.datetime "start_date"
    t.datetime "expected_end_date"
    t.datetime "actual_end_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "creation_reason"
  end

  add_index "subscription_periods", ["subscription_id"], name: "index_subscription_periods_on_subscription_id", using: :btree

  create_table "subscription_skipped_months", force: :cascade do |t|
    t.integer  "subscription_id"
    t.string   "month_year"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "subscription_skipped_months", ["subscription_id"], name: "index_subscription_skipped_months_on_subscription_id", using: :btree

  create_table "subscription_units", force: :cascade do |t|
    t.integer  "subscription_id"
    t.string   "tracking_number"
    t.string   "shipstation_id"
    t.string   "carrier_code"
    t.string   "service_code"
    t.string   "month_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shirt_size"
    t.string   "netsuite_sku"
    t.integer  "shipping_address_id"
    t.string   "shipstation_order_number"
    t.integer  "subscription_period_id"
    t.string   "status"
  end

  add_index "subscription_units", ["month_year"], name: "index_subscription_units_on_month_year", using: :btree
  add_index "subscription_units", ["shipstation_order_number"], name: "index_subscription_units_on_shipstation_order_number", using: :btree
  add_index "subscription_units", ["shirt_size"], name: "index_subscription_units_on_shirt_size", using: :btree
  add_index "subscription_units", ["subscription_period_id"], name: "index_subscription_units_on_subscription_period_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "shirt_size"
    t.integer  "customer_id"
    t.integer  "plan_id"
    t.float    "cost"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "looter_name"
    t.string   "coupon_code"
    t.string   "last_4"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current"
    t.integer  "chargify_subscription_id"
    t.string   "subscription_status",      default: "active"
    t.boolean  "braintree"
    t.boolean  "cancel_at_end_of_period"
    t.datetime "last_payment_date"
    t.datetime "creation_date"
    t.datetime "next_assessment_at"
    t.string   "recurly_subscription_id"
    t.string   "recurly_account_id"
    t.string   "name"
  end

  add_index "subscriptions", ["billing_address_id"], name: "index_subscriptions_on_billing_address_id", using: :btree
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["recurly_account_id"], name: "index_subscriptions_on_recurly_account_id", using: :btree
  add_index "subscriptions", ["recurly_subscription_id"], name: "index_subscriptions_on_recurly_subscription_id", using: :btree
  add_index "subscriptions", ["shipping_address_id"], name: "index_subscriptions_on_shipping_address_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "account_status"
    t.string   "spree_password_hash"
    t.string   "spree_password_salt"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "variants", force: :cascade do |t|
    t.string   "sku"
    t.string   "name"
    t.integer  "product_id"
    t.boolean  "is_master"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "recurly_accounts", "users"
  add_foreign_key "subscription_periods", "subscriptions"
  add_foreign_key "subscription_skipped_months", "subscriptions"
end
