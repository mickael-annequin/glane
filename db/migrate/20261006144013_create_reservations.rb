class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :listing, null: false, foreign_key: true
      # The structure that reserves (the beneficiary), and the person who reserved.
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :pickup_at, null: false # the chosen pickup slot
      t.string :status, null: false, default: "active"
      t.references :cancelled_by, foreign_key: { to_table: :users }
      t.datetime :closed_at # when it ended: picked up, not picked up or cancelled

      t.timestamps
    end
    # At most one active reservation per listing: if two structures reserve at the same second,
    # the database itself refuses the second one.
    add_index :reservations, :listing_id, unique: true, where: "status = 'active'", name: "index_reservations_one_active_per_listing"
  end
end
