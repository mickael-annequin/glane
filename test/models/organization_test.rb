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

    assert_equal [ users(:marie), users(:sophie) ].sort, organization.active_members.to_a.sort
  end

  test "is active until it is deactivated" do
    assert organizations(:secours_chartres).active?
    assert_not organizations(:closed).active?
  end

  test "keeps the position of the picked address suggestion" do
    organization = organizations(:restos_dreux)
    organization.update!(address: "3 Place des Halles 28000 Chartres", latitude: 48.4457, longitude: 1.4867, city: "Chartres")

    assert_equal "Chartres", organization.city
  end

  test "refuses a new address typed without picking a suggestion" do
    organization = organizations(:restos_dreux)

    assert_not organization.update(address: "1 rue des licornes, Chartres")
    assert_includes organization.errors[:address].first, "liste des suggestions"

    new_organization = Organization.new(name: "Nouvelle", address: "Quelque part")
    assert_not new_organization.valid?
  end

  test "other changes don't need a new address" do
    assert organizations(:restos_dreux).update(phone: "02 37 00 00 00")
  end
end
