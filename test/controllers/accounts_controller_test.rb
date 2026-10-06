require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:paul) }

  test "follows every category by default" do
    get edit_account_path

    assert_select "input[name='followed_category_ids[]'][type=checkbox][checked]", count: 4
  end

  test "changes the name, the phone and the followed categories" do
    patch account_path, params: { user: { name: "Paul M.", phone: "06 11 22 33 44" },
                                  followed_category_ids: [ "", categories(:vegetables).id, categories(:other).id ] }

    assert_redirected_to organization_path
    paul = users(:paul).reload
    assert_equal "Paul M.", paul.name
    assert_equal [ categories(:vegetables), categories(:other) ], paul.followed_categories.to_a
  end

  test "a new category is followed automatically" do
    users(:paul).follow_only([ categories(:vegetables).id ])
    boissons = Category.create!(name: "Boissons")

    assert_includes users(:paul).followed_categories, boissons
  end

  test "the name is required" do
    patch account_path, params: { user: { name: "" } }

    assert_response :unprocessable_content
  end
end
