require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "shows the home page" do
    get root_url
    assert_response :success
    assert_select "h1", /Glane/
  end
end
