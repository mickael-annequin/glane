require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "needs a name and an address" do
    organization = Organization.new

    assert_not organization.valid?
    assert_includes organization.errors[:name], "doit être rempli(e)"
    assert_includes organization.errors[:address], "doit être rempli(e)"
  end

  test "counts the people who can use Glane" do
    organization = organizations(:secours_chartres)
    User.invite!({ email: "pending@glane.test", organization: organization }, users(:admin))

    assert_equal [ users(:marie) ], organization.active_members.to_a
  end

  test "is active until it is deactivated" do
    assert organizations(:secours_chartres).active?
    assert_not organizations(:closed).active?
  end
end
