require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:admin) }

  test "only the admin can manage the categories" do
    sign_in users(:paul)
    get admin_categories_path

    assert_redirected_to root_path
  end

  test "lists the categories in order, with the catch-all last" do
    get admin_categories_path

    assert_response :success
    assert_select ".category-name", count: 4
    assert_select ".list-group-item:last-child .category-name", /Autres/
  end

  test "adds a category" do
    post admin_categories_path, params: { category: { name: "Boissons", icon: "🧃" } }

    assert_redirected_to admin_categories_path
    assert_equal "Boissons", Category.ordered.where(catch_all: false).last.name
  end

  test "refuses a category without a name" do
    post admin_categories_path, params: { category: { name: "" } }

    assert_response :unprocessable_content
    assert_select ".alert", /Nom doit être rempli/
  end

  test "renames and hides a category" do
    patch admin_category_path(categories(:dairy)), params: { category: { name: "Laitages", hidden: "1" } }

    assert_redirected_to admin_categories_path
    assert_equal "Laitages", categories(:dairy).reload.name
    assert categories(:dairy).hidden?
  end

  test "can't hide the catch-all category" do
    patch admin_category_path(categories(:other)), params: { category: { hidden: "1" } }

    assert_response :unprocessable_content
    assert_not categories(:other).reload.hidden?
  end

  test "moves a category up" do
    patch move_admin_category_path(categories(:dry_goods), direction: :up)

    assert_redirected_to admin_categories_path
    assert_equal [ "Fruits et légumes", "Épicerie sèche", "Produits laitiers, œufs", "Autres" ], Category.ordered.pluck(:name)
  end
end
