class CreateAuditLogs < ActiveRecord::Migration[5.0]
  def change
    create_table "audit_logs", force: :cascade do |t|
      t.integer "user_id", null: false
      t.string "action", null: false
      t.integer "record_id", null: false
      t.string "record_type", null: false
      t.text "payload"
      t.text "request"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["record_type", "record_id"], using: :btree
      t.index ["user_id", "action"], using: :btree
      t.index ["action"], using: :btree
    end
  end
end
