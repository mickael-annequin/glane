require "test_helper"

class ListingsMapTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:paul)
    @previous_key = ENV["MAPBOX_API_KEY"]
    ENV["MAPBOX_API_KEY"] = "pk.test"
  end

  teardown { ENV["MAPBOX_API_KEY"] = @previous_key }

  def places
    JSON.parse(css_select("[data-controller=listings-map]").first["data-listings-map-places-value"])
  end

  test "shows the map with one place per pickup address, and my structure" do
    get root_path(view: "map")

    assert_response :success
    assert_select ".view-toggle a.active", "Carte"
    assert_select ".listing-card", count: 0
    assert_equal [ "Carottes", "Yaourts nature" ], places.flat_map { |place| place["listings"].map { |listing| listing["title"] } }.sort
    assert_select "[data-listings-map-home-value=?]", [ 1.3664, 48.7366 ].to_json
  end

  test "groups the listings published at the same place" do
    listings(:withdrawn_bread).update!(status: :available) # also at Place Métézeau, Dreux
    get root_path(view: "map")

    dreux = places.find { |place| place["count"] == 2 }
    assert_equal [ "Carottes", "Pain de mie" ], dreux["listings"].map { |listing| listing["title"] }.sort
  end

  test "keeps the category filter on the map" do
    get root_path(view: "map", category: categories(:dairy).id)

    assert_equal [ "Yaourts nature" ], places.flat_map { |place| place["listings"].map { |listing| listing["title"] } }
    assert_select ".category-chip.active[href*='view=map']"
  end

  test "the listing page opens the map centered on it" do
    get listing_path(listings(:yogurts))
    assert_select "a[href=?]", root_path(view: "map", focus: listings(:yogurts).id)

    get root_path(view: "map", focus: listings(:yogurts).id)
    assert_select "[data-listings-map-focus-value=?]", listings(:yogurts).id.to_s
  end

  test "says so when the map key is missing" do
    ENV["MAPBOX_API_KEY"] = nil
    get root_path(view: "map")

    assert_select "[data-controller=listings-map]", count: 0
    assert_select "p", /La carte n'est pas disponible/
  end
end
