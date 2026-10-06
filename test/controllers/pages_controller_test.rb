require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "shows the home page with the person and their structure" do
    sign_in users(:marie)
    get root_url

    assert_response :success
    assert_select "h1", /Glane/
    assert_select "p", /Marie Dupont\s+\(Secours Populaire Chartres\)/
  end
end
