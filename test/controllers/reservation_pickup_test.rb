require "test_helper"

# The potatoes of Chartres (Marie) are reserved by Dreux (Paul): see the fixtures.
class ReservationPickupTest < ActionDispatch::IntegrationTest
  test "the donor closes: the listing goes to the history of both structures" do
    sign_in users(:marie)
    get listing_path(listings(:potatoes))
    assert_select "button", "✓ Stock récupéré"

    patch pick_up_reservation_path(reservations(:potatoes_by_dreux))

    assert_redirected_to exchanges_path
    assert reservations(:potatoes_by_dreux).reload.picked_up?
    assert listings(:potatoes).reload.picked_up?

    follow_redirect!
    assert_select ".exchange-list-past .exchange-row", /Pommes de terre.*Récupérée le .* par Restos du Cœur Dreux/m

    sign_in users(:paul)
    get exchanges_path(tab: "reservations")
    assert_select ".exchange-list-past .exchange-row", /Pommes de terre.*Récupérée le/m
  end

  test "the structure that reserved can't close" do
    sign_in users(:paul)
    get listing_path(listings(:potatoes))
    assert_select "button", { text: "✓ Stock récupéré", count: 0 }

    patch pick_up_reservation_path(reservations(:potatoes_by_dreux))

    assert_response :not_found
    assert reservations(:potatoes_by_dreux).reload.active?
  end
end
