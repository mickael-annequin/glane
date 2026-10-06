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

ActiveRecord::Schema[8.1].define(version: 2026_10_06_144857) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon"
    t.integer "position", default: 0, null: false
    t.boolean "hidden", default: false, null: false
    t.boolean "catch_all", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "category_opt_outs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_opt_outs_on_category_id"
    t.index ["user_id", "category_id"], name: "index_category_opt_outs_on_user_id_and_category_id", unique: true
    t.index ["user_id"], name: "index_category_opt_outs_on_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.string "title", null: false
    t.date "available_until", null: false
    t.decimal "quantity", precision: 10, scale: 2
    t.string "unit"
    t.string "storage"
    t.string "address", null: false
    t.string "city"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.text "availability_note"
    t.text "description"
    t.string "status", default: "available", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "schedule", default: {}, null: false
    t.index ["category_id"], name: "index_listings_on_category_id"
    t.index ["organization_id"], name: "index_listings_on_organization_id"
    t.index ["status", "available_until"], name: "index_listings_on_status_and_available_until"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "phone"
    t.text "usual_availability_note"
    t.datetime "deactivated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "usual_schedule", default: {}, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "pickup_at", null: false
    t.string "status", default: "active", null: false
    t.bigint "cancelled_by_id"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cancelled_by_id"], name: "index_reservations_on_cancelled_by_id"
    t.index ["listing_id"], name: "index_reservations_on_listing_id"
    t.index ["listing_id"], name: "index_reservations_one_active_per_listing", unique: true, where: "((status)::text = 'active'::text)"
    t.index ["organization_id"], name: "index_reservations_on_organization_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "organization_id"
    t.string "name", default: "", null: false
    t.string "phone"
    t.string "role", default: "member", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "deactivated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "category_opt_outs", "categories"
  add_foreign_key "category_opt_outs", "users"
  add_foreign_key "listings", "categories"
  add_foreign_key "listings", "organizations"
  add_foreign_key "listings", "users"
  add_foreign_key "reservations", "listings"
  add_foreign_key "reservations", "organizations"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "users", column: "cancelled_by_id"
  add_foreign_key "users", "organizations"
end
