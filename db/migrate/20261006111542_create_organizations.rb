class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.text :usual_availability
      t.datetime :deactivated_at

      t.timestamps
    end
  end
end
