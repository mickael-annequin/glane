require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  test "only the managers of a structure edit it" do
    assert OrganizationPolicy.new(users(:marie), organizations(:secours_chartres)).update?
    assert_not OrganizationPolicy.new(users(:sophie), organizations(:secours_chartres)).update?
    assert_not OrganizationPolicy.new(users(:marie), organizations(:restos_dreux)).update?
  end
end
