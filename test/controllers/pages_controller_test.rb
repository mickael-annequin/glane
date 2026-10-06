require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "shows the home page with the person and their structure" do
    sign_in users(:marie)
    get root_url

    assert_response :success
    assert_select "h1", /Glane/
    assert_select "p", /Marie Dupont\s+\(Secours Populaire Chartres\)/
  end

  test "asks a manager to complete the structure, until the availability is filled in" do
    sign_in users(:marie)
    get root_url
    assert_select ".todo-box", /Complétez la fiche de votre structure/

    organizations(:secours_chartres).update!(usual_availability: "Lun–ven 9h–17h")
    get root_url
    assert_select ".todo-box", count: 0
  end

  test "doesn't ask a member to complete the structure" do
    sign_in users(:paul)
    get root_url

    assert_select ".todo-box", count: 0
  end
end
