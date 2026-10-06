class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :icon
      t.integer :position, null: false, default: 0
      t.boolean :hidden, null: false, default: false
      # true for "Autres" only: always last, can't be hidden.
      t.boolean :catch_all, null: false, default: false

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
