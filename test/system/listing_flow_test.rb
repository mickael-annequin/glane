require "application_system_test_case"

# The whole flow: Chartres (Marie) publishes, Dreux (Paul) reserves, Chartres closes.
class ListingFlowTest < ApplicationSystemTestCase
  test "publish, reserve, then close" do
    pickup_day = Date.current + 2

    # Marie publishes. Her structure has no usual opening hours: she checks every day,
    # changes Monday to 10h–16h, then copies it to the other days.
    sign_in users(:marie)
    visit new_listing_path
    select "🥕 Fruits et légumes", from: "Catégorie *"
    fill_in "Produit *", with: "Courgettes"
    fill_in "À récupérer avant le *", with: Date.current + 5
    Schedule::DAYS.each_value { |name| check name.capitalize }
    select "10h00", from: "Lundi, plage 1, début", exact: true
    select "16h00", from: "Lundi, plage 1, fin", exact: true
    click_on "Copier les horaires du premier jour coché sur les autres jours cochés"
    click_on "Publier"

    assert_text "Votre annonce est en ligne."
    assert_text "Du lundi au dimanche : 10h–16h"

    # Paul finds it on the home page and reserves it in two days, at 14h.
    sign_out :user
    sign_in users(:paul)
    visit root_path
    click_on "Courgettes"
    click_on "Réserver"
    find("label[for='pickup_day_#{pickup_day.iso8601}']").click
    select "14h00", from: "Heure", exact: true
    click_on "Confirmer la réservation"

    assert_text "C'est réservé !"
    assert_text "Réservée par votre structure (Paul Martin)"
    assert_equal pickup_day.in_time_zone.change(hour: 14), Reservation.last.pickup_at

    # Marie says the stock is gone: the listing goes to the history.
    sign_out :user
    sign_in users(:marie)
    visit listing_path(Listing.find_by!(title: "Courgettes"))
    assert_text "Réservée par Restos du Cœur Dreux (Paul Martin)"
    accept_confirm { click_on "✓ Stock récupéré" }

    assert_text "C'est noté : « Courgettes » est récupérée. Merci pour ce don !"
    within(".exchange-list-past") { assert_text "Courgettes" }
  end
end
