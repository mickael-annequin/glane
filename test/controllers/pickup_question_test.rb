require "test_helper"

# The potatoes of Chartres (Marie) are reserved by Dreux (Paul): see the fixtures.
# Here, Paul should have come 4 hours ago and nobody closed the reservation.
class PickupQuestionTest < ActionDispatch::IntegrationTest
  setup do
    reservations(:potatoes_by_dreux).update!(pickup_at: 4.hours.ago)
  end

  test "the donor is asked on the home page and in Mes échanges" do
    sign_in users(:marie)

    get root_path
    assert_select ".todo-box", /Restos du Cœur Dreux devait passer .* chercher «.Pommes de terre.»/m
    assert_select ".todo-box button", "✗ Non, remettre en ligne"

    get exchanges_path
    assert_select ".todo-box", /Pommes de terre/
  end

  test "not asked before 3 hours, nor to the structure that reserved" do
    sign_in users(:paul)
    get root_path
    assert_select ".todo-box", text: /stock est-il parti/, count: 0

    reservations(:potatoes_by_dreux).update!(pickup_at: 1.hour.ago)
    sign_in users(:marie)
    get root_path
    assert_select ".todo-box", text: /stock est-il parti/, count: 0
  end

  test "yes: the listing is closed" do
    sign_in users(:marie)
    patch pick_up_reservation_path(reservations(:potatoes_by_dreux))

    assert reservations(:potatoes_by_dreux).reload.picked_up?
    get root_path
    assert_select ".todo-box", text: /stock est-il parti/, count: 0
  end

  test "no: the listing is offered again, and the beneficiary sees it in its history" do
    sign_in users(:marie)
    patch not_picked_up_reservation_path(reservations(:potatoes_by_dreux))

    assert_redirected_to exchanges_path
    assert listings(:potatoes).reload.reservable?
    assert_match "de nouveau proposée", flash[:notice]

    sign_in users(:paul)
    get exchanges_path(tab: "reservations")
    assert_select ".exchange-list-past .exchange-row", /Pommes de terre.*Non récupérée/m
    get root_path
    assert_select ".listing-card-title", "Pommes de terre"
  end

  test "no, after the deadline: the listing goes to the history" do
    listings(:potatoes).update_column(:available_until, Date.yesterday)
    sign_in users(:marie)
    get root_path
    assert_select ".todo-box button", "✗ Non, pas récupéré"

    patch not_picked_up_reservation_path(reservations(:potatoes_by_dreux))
    follow_redirect!
    assert_select ".exchange-list-past .exchange-row", /Pommes de terre.*Date limite dépassée/m
  end

  test "the second member to answer is told it's already done" do
    sign_in users(:marie)
    patch pick_up_reservation_path(reservations(:potatoes_by_dreux))
    patch not_picked_up_reservation_path(reservations(:potatoes_by_dreux))

    assert_redirected_to root_path
    assert_equal "C'est déjà réglé : un autre membre a répondu, ou la réservation a été annulée.", flash[:alert]
    assert reservations(:potatoes_by_dreux).reload.picked_up?
  end

  test "the structure that reserved can't answer" do
    sign_in users(:paul)
    patch not_picked_up_reservation_path(reservations(:potatoes_by_dreux))

    assert_redirected_to root_path
    assert reservations(:potatoes_by_dreux).reload.active?
  end
end
