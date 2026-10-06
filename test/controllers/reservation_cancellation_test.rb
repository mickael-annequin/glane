require "test_helper"

# The potatoes of Chartres (Marie) are reserved by Dreux (Paul): see the fixtures.
class ReservationCancellationTest < ActionDispatch::IntegrationTest
  test "the structure that reserved cancels: the listing is offered again" do
    sign_in users(:paul)
    patch cancel_reservation_path(reservations(:potatoes_by_dreux))

    assert_redirected_to listing_path(listings(:potatoes))
    reservation = reservations(:potatoes_by_dreux).reload
    assert reservation.cancelled?
    assert_equal users(:paul), reservation.cancelled_by
    assert listings(:potatoes).reload.available?

    get root_path
    assert_select ".listing-card-title", "Pommes de terre"
  end

  test "the donor cancels" do
    sign_in users(:marie)
    get listing_path(listings(:potatoes))
    assert_select "button", "Annuler la réservation"

    patch cancel_reservation_path(reservations(:potatoes_by_dreux))

    assert reservations(:potatoes_by_dreux).reload.cancelled_by_donor?
    assert listings(:potatoes).reload.available?
  end

  test "another structure can't cancel" do
    other = Organization.create!(name: "CCAS de Lucé", address: "Place de la Mairie 28110 Lucé", latitude: 48.437, longitude: 1.465)
    sign_in User.create!(email: "luce@glane.test", password: "password", name: "Léa", organization: other)
    patch cancel_reservation_path(reservations(:potatoes_by_dreux))

    assert_response :not_found
    assert reservations(:potatoes_by_dreux).reload.active?
  end

  test "the Réservations tab shows the next pickups, then the history" do
    sign_in users(:paul)
    get exchanges_path(tab: "reservations")

    assert_select ".admin-tabs a.active", "Réservations (1)"
    assert_select ".exchange-list:not(.exchange-list-past) .exchange-row", /Pommes de terre.*Passage demain à 14h/m

    patch cancel_reservation_path(reservations(:potatoes_by_dreux))
    get exchanges_path(tab: "reservations")
    assert_select ".exchange-list-past .exchange-row", /Annulée par votre structure/
  end

  test "the structure that reserved sees the cancel button" do
    sign_in users(:paul)
    get listing_path(listings(:potatoes))

    assert_select "button", "Annuler ma réservation"
  end
end
