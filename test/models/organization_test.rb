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

  test "finds the position and the city of a new address" do
    organization = organizations(:restos_dreux)
    organization.update!(address: "3 place des Halles, Chartres")

    assert_equal 48.4469, organization.latitude
    assert_equal "Chartres", organization.city
  end

  test "refuses an address that can't be found" do
    organization = organizations(:restos_dreux)

    assert_not organization.update(address: "1 rue introuvable")
    assert_includes organization.errors[:address].first, "introuvable"
  end

  test "saves the address anyway when the IGN can't be reached" do
    with_geocoding_unavailable do
      organization = organizations(:restos_dreux)

      assert organization.update(address: "3 place des Halles, Chartres")
      assert_not organization.located?
    end
  end
end
