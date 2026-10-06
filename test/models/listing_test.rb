require "test_helper"

class ListingTest < ActiveSupport::TestCase
  def new_listing(attributes = {})
    listing = Listing.new_from(users(:marie))
    listing.assign_attributes({ category: categories(:vegetables), title: "Pommes de terre" }.merge(attributes))
    listing
  end

  test "copies the pickup place and the availability of the structure" do
    organizations(:secours_chartres).update!(usual_availability: "Lun–ven 9h–17h")
    listing = new_listing

    assert_equal "12 rue des Écuyers, 28000 Chartres", listing.address
    assert_equal "Lun–ven 9h–17h", listing.availability
    assert listing.valid?, listing.errors.full_messages.to_sentence
  end

  test "needs a category, a product, a date and the availability" do
    listing = new_listing(category: nil, title: "", available_until: nil, availability: "")

    assert_not listing.valid?
    assert_equal %i[available_until availability category title].sort, listing.errors.attribute_names.uniq.sort
  end

  test "refuses a date in the past" do
    listing = new_listing(available_until: Date.yesterday, availability: "Lundi")

    assert_not listing.valid?
    assert_includes listing.errors[:available_until], "ne peut pas être dans le passé"
  end

  test "a quantity goes with a unit" do
    assert_not new_listing(quantity: "12", availability: "Lundi").valid?
    assert_not new_listing(unit: "kg", availability: "Lundi").valid?
    assert new_listing(quantity: "12", unit: "kg", availability: "Lundi").valid?
  end

  test "reads a quantity with a French comma, and shows it with the right unit" do
    assert_equal "2,5 kg", new_listing(quantity: "2,5", unit: "kg").quantity_label
    assert_equal "1 carton", new_listing(quantity: "1", unit: "box").quantity_label
    assert_equal "40 pièces", listings(:yogurts).quantity_label
    assert_nil new_listing.quantity_label
  end

  test "a hidden category isn't offered any more" do
    categories(:vegetables).update!(hidden: true)

    assert_not new_listing(availability: "Lundi").valid?
  end

  test "only available listings before their date can be reserved" do
    assert_equal [ listings(:carrots), listings(:yogurts) ].sort, Listing.reservable.to_a.sort
    assert listings(:old_milk).expired?
  end
end
