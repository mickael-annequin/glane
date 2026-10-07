require "test_helper"

# db/seeds/demo.rb runs at each deploy on Render when DEMO_PASSWORD is set: it must never fail.
class DemoTest < ActiveSupport::TestCase
  def load_demo
    ENV["DEMO_PASSWORD"] = "demo1234"
    capture_io { load Rails.root.join("db/seeds/demo.rb") } # hides its "Demo data ready" message
  ensure
    ENV.delete("DEMO_PASSWORD")
  end

  test "creates the demo data, and replaces it at each run" do
    load_demo
    load_demo

    demo_organizations = Organization.where(id: User.where("email LIKE ?", "%@demo.test").select(:organization_id))
    assert_equal 6, demo_organizations.count
    assert_equal 12, Listing.where(organization: demo_organizations).reservable.count

    chartres = User.find_by!(email: "chartres@demo.test")
    assert chartres.valid_password?("demo1234")
    assert_equal [ "Brioches" ], chartres.organization.pickups_to_confirm.map { |reservation| reservation.listing.title }
  end
end
