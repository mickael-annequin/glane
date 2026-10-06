# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Glane
      # Empty only for the admin, who doesn't have to belong to a structure.
      t.references :organization, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :phone
      t.string :role, null: false, default: "member"
      t.boolean :admin, null: false, default: false
      t.datetime :deactivated_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
