require "test_helper"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  test "shows my account and my structure, with its place on a map" do
    sign_in users(:paul)
    get organization_path

    assert_response :success
    assert_select ".info-card", /Paul Martin/
    assert_select ".info-card", /Restos du Cœur Dreux/
    assert_select "a[href*='openstreetmap.org/?mlat=48.7366']"
    assert_select "a", text: "Modifier la structure", count: 0
  end

  test "a manager edits the structure, and the new address is placed on the map" do
    sign_in users(:marie)
    patch organization_path, params: { organization: { address: "3 Place des Halles 28000 Chartres", latitude: "48.4457", longitude: "1.4867",
                                                       city: "Chartres", usual_availability: "Lun–ven 9h–17h" } }

    assert_redirected_to organization_path
    organization = organizations(:secours_chartres).reload
    assert_equal "Lun–ven 9h–17h", organization.usual_availability
    assert_equal "Chartres", organization.city
  end

  test "an address typed without picking a suggestion is refused" do
    sign_in users(:marie)
    patch organization_path, params: { organization: { address: "1 rue des licornes", latitude: "", longitude: "", city: "" } }

    assert_response :unprocessable_content
    assert_select ".alert", /Adresse doit être choisie dans la liste des suggestions/
    assert_select "[data-controller=address-autocomplete]"
  end

  test "a member can't edit the structure" do
    sign_in users(:paul)

    get edit_organization_path
    assert_redirected_to organization_path

    patch organization_path, params: { organization: { name: "Piraté" } }
    assert_equal "Restos du Cœur Dreux", organizations(:restos_dreux).reload.name
  end

  test "the admin without a structure sees only the account" do
    sign_in users(:admin)
    get organization_path

    assert_response :success
    assert_select ".info-card", count: 1
    assert_select "a[href=?]", admin_root_path
  end
end
