# The categories a person does NOT follow. By default a person follows every category,
# including the ones the admin adds later.
class CreateCategoryOptOuts < ActiveRecord::Migration[8.1]
  def change
    create_table :category_opt_outs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :category_opt_outs, %i[user_id category_id], unique: true
  end
end
