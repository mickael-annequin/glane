require "test_helper"

# Marie is in Chartres, Paul in Dreux. Potatoes (Chartres) are reserved by Dreux: see the fixtures.
class ListingPolicyTest < ActiveSupport::TestCase
  def policy(user, listing)
    ListingPolicy.new(users(user), listings(listing))
  end

  test "a structure can't edit or withdraw the listing of another one" do
    assert policy(:marie, :yogurts).update?
    assert_not policy(:paul, :yogurts).update?
    assert_not policy(:paul, :yogurts).withdraw?
  end

  test "a reserved or withdrawn listing can't change any more" do
    assert_not policy(:marie, :potatoes).update?
    assert_not policy(:paul, :withdrawn_bread).update?
  end

  test "who sees a listing" do
    assert policy(:paul, :yogurts).show?             # can be reserved
    assert policy(:marie, :old_milk).show?           # past its date, but my structure's
    assert_not policy(:paul, :old_milk).show?
    assert policy(:paul, :potatoes).show?            # reserved by my structure
    assert policy(:paul, :withdrawn_bread).show?     # withdrawn, but my structure's
    assert_not policy(:marie, :withdrawn_bread).show?
  end

  test "only the people of a structure publish" do
    assert ListingPolicy.new(users(:paul), Listing).create?
    assert_not ListingPolicy.new(users(:admin), Listing).create?
  end

  test "the listings I can see" do
    visible = ListingPolicy::Scope.new(users(:paul), Listing).resolve
    assert_includes visible, listings(:yogurts)
    assert_includes visible, listings(:potatoes)
    assert_includes visible, listings(:withdrawn_bread)
    assert_not_includes visible, listings(:old_milk)
  end
end
