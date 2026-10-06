require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  def another_structure
    Organization.create!(name: "CCAS de Lucé", address: "Place de la Mairie 28110 Lucé", latitude: 48.437, longitude: 1.465, city: "Lucé")
  end

  def reservation(listing, organization:, pickup_at: Date.tomorrow.in_time_zone.change(hour: 10))
    user = organization.users.first || User.create!(email: "#{organization.id}@glane.test", password: "password", name: "Quelqu'un", organization: organization)
    Reservation.new(listing: listing, organization: organization, user: user, pickup_at: pickup_at)
  end

  test "books an available listing, which becomes reserved" do
    booking = reservation(listings(:carrots), organization: organizations(:secours_chartres))

    assert booking.book
    assert booking.active?
    assert listings(:carrots).reload.reserved?
  end

  test "the second structure can't reserve a listing already reserved" do
    assert reservation(listings(:carrots), organization: organizations(:secours_chartres)).book

    late = reservation(listings(:carrots), organization: another_structure)
    assert_not late.book
    assert_includes late.errors[:base], Reservation::ALREADY_TAKEN
  end

  test "the database itself refuses two active reservations for one listing" do
    first = reservation(listings(:carrots), organization: organizations(:secours_chartres))
    first.save!

    assert_raises(ActiveRecord::RecordNotUnique) do
      reservation(listings(:carrots), organization: another_structure).save!(validate: false)
    end
  end

  test "can't reserve a listing of my own structure" do
    booking = reservation(listings(:yogurts), organization: organizations(:secours_chartres))

    assert_not booking.book
  end

  test "the slot must be in the future, and not after the deadline" do
    assert_not reservation(listings(:carrots), organization: organizations(:secours_chartres), pickup_at: 2.hours.ago).book
    assert_not reservation(listings(:carrots), organization: organizations(:secours_chartres), pickup_at: 10.days.from_now).book
  end

  test "the contact phone is the person's, or else the structure's" do
    assert_equal "06 12 34 56 78", Reservation.contact_phone(users(:marie))
    organizations(:restos_dreux).update!(phone: "02 37 00 00 02")
    assert_equal "02 37 00 00 02", Reservation.contact_phone(users(:paul))
  end
end
