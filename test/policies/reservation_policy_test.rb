require "test_helper"

# Marie is in Chartres, Paul in Dreux. Potatoes (Chartres) are reserved by Dreux: see the fixtures.
class ReservationPolicyTest < ActiveSupport::TestCase
  def new_reservation(user, listing)
    ReservationPolicy.new(users(user), listings(listing).reservations.new)
  end

  def policy(user)
    ReservationPolicy.new(users(user), reservations(:potatoes_by_dreux))
  end

  test "a structure reserves the listings of the other ones, while they can be reserved" do
    assert new_reservation(:paul, :yogurts).create?
    assert_not new_reservation(:marie, :yogurts).create?   # my structure's
    assert_not new_reservation(:paul, :potatoes).create?   # already reserved
    assert_not new_reservation(:paul, :old_milk).create?   # past its date
    assert_not new_reservation(:admin, :yogurts).create?   # no structure
  end

  test "both structures can cancel" do
    assert policy(:paul).cancel?
    assert policy(:marie).cancel?
  end

  test "only the donor closes" do
    assert policy(:marie).pick_up?
    assert policy(:marie).not_picked_up?
    assert_not policy(:paul).pick_up?
    assert_not policy(:paul).not_picked_up?
  end

  test "a closed reservation can't change any more" do
    reservations(:potatoes_by_dreux).pick_up!

    assert_not policy(:marie).pick_up?
    assert_not policy(:paul).cancel?
  end
end
