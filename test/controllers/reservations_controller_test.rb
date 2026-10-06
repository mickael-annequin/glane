require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:paul) } # Restos du Cœur Dreux

  def book(listing, day: Date.tomorrow, hour: "14:00")
    post listing_reservations_path(listing), params: { reservation: { pickup_day: day.iso8601, pickup_hour: hour } }
  end

  test "offers the days until the deadline, and the donor's opening hours" do
    travel_to Time.current.change(hour: 10) # in the morning, today still has opening times
    get new_listing_reservation_path(listings(:yogurts)) # deadline: tomorrow, open every day 9h–17h

    assert_response :success
    assert_select "input[name='reservation[pickup_day]']", count: 2
    assert_select "label", "Aujourd'hui"
    assert_select "label", "Demain"
    assert_select ".info-card", /Du lundi au dimanche : 9h–17h/
  end

  test "only offers the open days, and their hours" do
    travel_to Time.current.change(hour: 10)
    open_day = Date.current + 2
    listings(:carrots).update_columns(organization_id: organizations(:secours_chartres).id, available_until: Date.current + 6,
                                      schedule: { open_day.cwday.to_s => [ %w[10:00 11:00] ] })
    get new_listing_reservation_path(listings(:carrots))

    assert_select "input[name='reservation[pickup_day]']", count: 1
    assert_select "input[name='reservation[pickup_day]'][value=?]", open_day.iso8601
    assert_select "select[name='reservation[pickup_hour]'] option[value]:not([value=''])", count: 4 # 10h, 10h15, 10h30, 10h45
    times = JSON.parse(css_select("form[data-controller=pickup-slot]").first["data-pickup-slot-times-value"])
    assert_equal({ open_day.iso8601 => %w[10:00 10:15 10:30 10:45] }, times)
  end

  test "refuses a time outside the opening hours" do
    listings(:yogurts).update_columns(schedule: (1..7).to_h { |day| [ day.to_s, [ %w[09:00 12:00] ] ] })
    book(listings(:yogurts), hour: "14:00")

    assert_response :unprocessable_content
    assert_select ".alert", /Le créneau n'est pas dans les disponibilités du donateur/
  end

  test "reserves a listing: it is attributed and leaves the list" do
    assert_difference "Reservation.count", 1 do
      book(listings(:yogurts))
    end

    assert_redirected_to listing_path(listings(:yogurts))
    assert_match "C'est réservé ! Passage prévu demain à 14h", flash[:notice]
    reservation = Reservation.last
    assert_equal organizations(:restos_dreux), reservation.organization
    assert_equal users(:paul), reservation.user
    assert listings(:yogurts).reload.reserved?

    get root_path
    assert_select ".listing-card-title", text: "Yaourts nature", count: 0
  end

  test "the structure that reserved sees the slot and the donor's phone" do
    book(listings(:yogurts))
    follow_redirect!

    assert_select ".reservation-card", /Réservée par votre structure \(Paul Martin\)/
    assert_select ".reservation-card", /Passage prévu demain à 14h/
    assert_select ".reservation-card a[href=?]", "tel:0612345678"
  end

  test "the donor sees who comes and when" do
    sign_in users(:marie)
    get listing_path(listings(:potatoes))

    assert_select ".reservation-card", /Réservée par Restos du Cœur Dreux \(Paul Martin\)/
    assert_select ".reservation-card", /Pas de téléphone renseigné/
    assert_select "a", text: "Modifier", count: 0
  end

  test "a reserved listing is hidden from the other structures" do
    other = Organization.create!(name: "CCAS de Lucé", address: "Place de la Mairie 28110 Lucé", latitude: 48.437, longitude: 1.465)
    sign_in User.create!(email: "luce@glane.test", password: "password", name: "Léa", organization: other)
    get listing_path(listings(:potatoes))

    assert_redirected_to root_path
  end

  test "a listing already reserved can't be reserved again" do
    get new_listing_reservation_path(listings(:potatoes))

    assert_redirected_to root_path
  end

  test "can't reserve a listing of my structure" do
    get new_listing_reservation_path(listings(:carrots))

    assert_redirected_to listing_path(listings(:carrots))
  end

  test "asks for a day and an hour, in the future" do
    book(listings(:yogurts), hour: "")
    assert_response :unprocessable_content
    assert_select ".alert", /Le créneau doit être choisi/

    book(listings(:yogurts), day: Date.yesterday)
    assert_select ".alert", /Le créneau est déjà passé/
    assert listings(:yogurts).reload.available?
  end

  test "the listing page offers to reserve" do
    get listing_path(listings(:yogurts))

    assert_select "a[href=?]", new_listing_reservation_path(listings(:yogurts)), text: "Réserver"
  end
end
