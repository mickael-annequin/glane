require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:marie) }

  def listing_params(attributes = {})
    { category_id: categories(:vegetables).id, title: "Pommes de terre", available_until: 5.days.from_now.to_date,
      availability: "Lun–ven 9h–17h", address: "12 rue des Écuyers, 28000 Chartres" }.merge(attributes)
  end

  test "the form is filled with the place and availability of my structure" do
    organizations(:secours_chartres).update!(usual_availability: "Le mercredi")
    get new_listing_path

    assert_response :success
    assert_select "input[name='listing[address]'][value=?]", "12 rue des Écuyers, 28000 Chartres"
    assert_select "textarea[name='listing[availability]']", "Le mercredi"
  end

  test "publishes a listing with only the required fields" do
    assert_difference "Listing.count", 1 do
      post listings_path, params: { listing: listing_params }
    end

    listing = Listing.last
    assert_redirected_to listing_path(listing)
    assert_equal organizations(:secours_chartres), listing.organization
    assert_equal users(:marie), listing.user
    assert_equal 48.4469, listing.latitude
    assert listing.available?
  end

  test "publishes a listing with every field" do
    post listings_path, params: { listing: listing_params(quantity: "12,5", unit: "kg", storage: "chilled", description: "Bien frais",
                                                          address: "Place Métézeau 28100 Dreux", latitude: "48.73577", longitude: "1.368172", city: "Dreux") }

    listing = Listing.last
    assert_equal "12,5 kg", listing.quantity_label
    assert_equal "Frais", listing.storage_label
    assert_equal "Dreux", listing.city
  end

  test "shows the errors in French" do
    post listings_path, params: { listing: listing_params(title: "", available_until: "") }

    assert_response :unprocessable_content
    assert_select ".alert", /Produit doit être rempli/
    assert_select ".alert", /La date limite doit être remplie|La date limite doit être rempli/
  end

  test "a person without a structure can't publish" do
    sign_in users(:admin)
    get new_listing_path

    assert_redirected_to organization_path
  end

  test "shows a listing to everyone, with the donor and the place" do
    sign_in users(:paul)
    get listing_path(listings(:yogurts))

    assert_response :success
    assert_select ".info-card", /Marie Dupont/
    assert_select "a[href*='google.com/maps/dir']"
    assert_select "a", text: "Modifier", count: 0
  end

  test "a listing that can't be reserved is hidden from the other structures" do
    sign_in users(:paul)

    get listing_path(listings(:old_milk))
    assert_redirected_to root_path

    get listing_path(listings(:withdrawn_bread))
    assert_response :success # it's Paul's own listing
  end

  test "edits my structure's listing" do
    patch listing_path(listings(:yogurts)), params: { listing: { title: "Yaourts aux fruits" } }

    assert_redirected_to listing_path(listings(:yogurts))
    assert_equal "Yaourts aux fruits", listings(:yogurts).reload.title
  end

  test "can't edit the listing of another structure" do
    patch listing_path(listings(:carrots)), params: { listing: { title: "Piraté" } }

    assert_response :not_found
    assert_equal "Carottes", listings(:carrots).reload.title
  end

  test "can't withdraw the listing of another structure" do
    patch withdraw_listing_path(listings(:carrots))

    assert_response :not_found
    assert listings(:carrots).reload.available?
  end

  test "withdraws a listing, which then can't be edited" do
    patch withdraw_listing_path(listings(:yogurts))

    assert_redirected_to exchanges_path
    assert listings(:yogurts).reload.withdrawn?

    get edit_listing_path(listings(:yogurts))
    assert_redirected_to listing_path(listings(:yogurts))
  end

  test "Mes échanges lists the listings of my structure" do
    get exchanges_path

    assert_response :success
    assert_select ".exchange-list:not(.exchange-list-past) .exchange-row", count: 2
    assert_select ".exchange-list:not(.exchange-list-past) .exchange-row", /Yaourts nature.*En ligne/m
    assert_select ".exchange-list:not(.exchange-list-past) .exchange-row", /Pommes de terre.*Réservée.*par Restos du Cœur Dreux/m
    assert_select ".exchange-list-past .exchange-row", /Lait demi-écrémé.*Date limite dépassée/m
  end

  def photo(name = "photo.png", type = "image/png")
    fixture_file_upload(name, type)
  end

  test "publishes a listing with photos, shown on its page" do
    post listings_path, params: { listing: listing_params(photos: [ "", photo, photo ]) }

    listing = Listing.last
    assert_equal 2, listing.photos.count
    follow_redirect!
    assert_select ".photo-gallery img", count: 2
  end

  test "photos are optional and never shown in the list" do
    post listings_path, params: { listing: listing_params(photos: [ "" ]) }
    assert_not Listing.last.photos.attached?

    listings(:yogurts).photos.attach(photo)
    get root_path
    assert_select ".listing-card img", count: 0
  end

  test "refuses more than 5 photos, or a file that isn't an image" do
    post listings_path, params: { listing: listing_params(photos: [ "" ] + Array.new(6) { photo }) }
    assert_select ".alert", /Les photos 5 au maximum/

    post listings_path, params: { listing: listing_params(photos: [ "", photo("notes.txt", "text/plain") ]) }
    assert_select ".alert", /Les photos doivent être des images/
  end

  test "keeps the checked photos and removes the unchecked ones" do
    listing = listings(:yogurts)
    listing.photos.attach([ photo, photo ])
    kept, removed = listing.photos.to_a

    patch listing_path(listing), params: { listing: { photos: [ kept.signed_id, "" ] } }

    assert_equal [ kept.blob_id ], listing.reload.photos.map(&:blob_id)
    assert_not_includes listing.photos.map(&:blob_id), removed.blob_id
  end

  test "adds photos to the ones already there" do
    listing = listings(:yogurts)
    listing.photos.attach(photo)

    patch listing_path(listing), params: { listing: { photos: [ listing.photos.first.signed_id, "", photo ] } }

    assert_equal 2, listing.reload.photos.count
  end
end
