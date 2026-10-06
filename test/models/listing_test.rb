require "test_helper"

class ListingTest < ActiveSupport::TestCase
  def new_listing(attributes = {})
    listing = Listing.new_from(users(:marie))
    listing.assign_attributes({ category: categories(:vegetables), title: "Pommes de terre", schedule: every_day_9_to_17 }.merge(attributes))
    listing
  end

  test "copies the pickup place and the opening hours of the structure" do
    organizations(:secours_chartres).update!(usual_schedule: { "3" => [ %w[14:00 17:00] ] }, usual_availability_note: "Sonner")
    listing = Listing.new_from(users(:marie))

    assert_equal "12 rue des Écuyers, 28000 Chartres", listing.address
    assert_equal "Mercredi : 14h–17h", listing.opening_hours.to_s
    assert_equal "Sonner", listing.availability_note
  end

  test "needs a category, a product, a date and at least one day of opening hours" do
    listing = new_listing(category: nil, title: "", available_until: nil, schedule: {})

    assert_not listing.valid?
    assert_equal %i[available_until category schedule title].sort, listing.errors.attribute_names.uniq.sort
  end

  test "refuses a time range that ends before it starts" do
    listing = new_listing(schedule: { "1" => [ %w[12:00 09:00] ] })

    assert_not listing.valid?
    assert_includes listing.errors[:schedule], "une plage horaire doit finir après son début"
  end

  test "a listing published before the planning existed stays valid without one" do
    listings(:carrots).update_columns(schedule: {})

    assert listings(:carrots).reload.update(title: "Carottes bio")
  end

  test "refuses a date in the past" do
    listing = new_listing(available_until: Date.yesterday)

    assert_not listing.valid?
    assert_includes listing.errors[:available_until], "ne peut pas être dans le passé"
  end

  test "a quantity goes with a unit" do
    assert_not new_listing(quantity: "12").valid?
    assert_not new_listing(unit: "kg").valid?
    assert new_listing(quantity: "12", unit: "kg").valid?
  end

  test "reads a quantity with a French comma, and shows it with the right unit" do
    assert_equal "2,5 kg", new_listing(quantity: "2,5", unit: "kg").quantity_label
    assert_equal "1 carton", new_listing(quantity: "1", unit: "box").quantity_label
    assert_equal "40 pièces", listings(:yogurts).quantity_label
    assert_nil new_listing.quantity_label
  end

  test "a hidden category isn't offered any more" do
    categories(:vegetables).update!(hidden: true)

    assert_not new_listing.valid?
  end

  test "only available listings before their date can be reserved" do
    assert_equal [ listings(:carrots), listings(:yogurts) ].sort, Listing.reservable.to_a.sort
    assert listings(:old_milk).expired?
  end
end
