require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "needs a unique name" do
    assert_not Category.new(name: "").valid?
    assert_not Category.new(name: "fruits et légumes").valid?
  end

  test "keeps the catch-all category last, even when a new category is added" do
    Category.create!(name: "Boissons")

    assert_equal [ "Fruits et légumes", "Produits laitiers, œufs", "Épicerie sèche", "Boissons", "Autres" ], Category.ordered.pluck(:name)
  end

  test "moves a category up and down" do
    categories(:dry_goods).move(:up)
    assert_equal [ "Fruits et légumes", "Épicerie sèche", "Produits laitiers, œufs", "Autres" ], Category.ordered.pluck(:name)

    categories(:vegetables).reload.move(:down)
    assert_equal [ "Épicerie sèche", "Fruits et légumes", "Produits laitiers, œufs", "Autres" ], Category.ordered.pluck(:name)
  end

  test "the first category can't go up, and the catch-all doesn't move" do
    categories(:vegetables).move(:up)
    categories(:other).move(:up)

    assert_equal [ "Fruits et légumes", "Produits laitiers, œufs", "Épicerie sèche", "Autres" ], Category.ordered.pluck(:name)
  end

  test "the catch-all category can't be hidden" do
    other = categories(:other)
    other.hidden = true

    assert_not other.valid?
    assert categories(:dairy).update(hidden: true)
  end
end
