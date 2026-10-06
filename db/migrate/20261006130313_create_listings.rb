class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      # The donor structure, and the person who published.
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false # the "produit"
      t.date :available_until, null: false # "À récupérer avant le…" (that day included)
      t.decimal :quantity, precision: 10, scale: 2
      t.string :unit
      t.string :storage
      # Pickup place: copied from the structure, can be changed for this listing.
      t.string :address, null: false
      t.string :city
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.text :availability, null: false
      t.text :description
      t.string :status, null: false, default: "available"

      t.timestamps
    end
    add_index :listings, %i[status available_until]
  end
end
