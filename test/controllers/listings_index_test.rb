require "test_helper"

class ListingsIndexTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:paul) } # Restos du Cœur Dreux

  test "the home page lists the listings that can be reserved, the most urgent first" do
    get root_path

    assert_response :success
    assert_select ".listing-card-title", count: 2
    assert_select ".listing-card:nth-child(1) .listing-card-title", "Yaourts nature" # tomorrow
    assert_select ".listing-card:nth-child(2) .listing-card-title", "Carottes"       # in 3 days
    assert_select ".listing-card-title", text: "Lait demi-écrémé", count: 0          # date passed
    assert_select ".listing-card-title", text: "Pain de mie", count: 0               # withdrawn
  end

  test "shows the city, the distance from my structure, and my own listings with a badge" do
    get root_path

    assert_select ".listing-card:nth-child(1)", /Chartres · 3\d km/
    assert_select ".listing-card:nth-child(2) .listing-card-badge", "Votre structure"
    assert_select ".listing-card:nth-child(1) .listing-card-badge", count: 0
  end

  test "filters by category" do
    get root_path(category: categories(:vegetables).id)

    assert_select ".listing-card-title", count: 1
    assert_select ".listing-card-title", "Carottes"
    assert_select ".category-chip.active", /Fruits et légumes/
  end

  test "says when there is nothing to show" do
    get root_path(category: categories(:dry_goods).id)

    assert_select ".listing-card", count: 0
    assert_select "p", /Aucune annonce dans cette catégorie/
  end

  test "asks a manager to complete the structure, until the availability is filled in" do
    sign_in users(:marie)
    get root_path
    assert_select ".todo-box", /Complétez la fiche de votre structure/

    organizations(:secours_chartres).update!(usual_availability: "Lun–ven 9h–17h")
    get root_path
    assert_select ".todo-box", count: 0
  end

  test "doesn't ask a member to complete the structure" do
    get root_path

    assert_select ".todo-box", count: 0
  end

  test "the admin without a structure sees the listings, without distances" do
    sign_in users(:admin)
    get root_path

    assert_response :success
    assert_select ".listing-card", count: 2
    assert_select ".listing-card-badge", count: 0
  end
end
