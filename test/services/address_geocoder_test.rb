require "test_helper"

class AddressGeocoderTest < ActiveSupport::TestCase
  test "reads the position and the city in the IGN answer" do
    json = { features: [ { geometry: { coordinates: [ 1.490509, 48.446156 ] },
                           properties: { score: 0.97, city: "Chartres", label: "12 Rue des Ecuyers 28000 Chartres" } } ] }.to_json

    result = AddressGeocoder.parse(json)

    assert_equal 48.446156, result.latitude
    assert_equal 1.490509, result.longitude
    assert_equal "Chartres", result.city
  end

  test "treats an empty or doubtful answer as not found" do
    assert_nil AddressGeocoder.parse({ features: [] }.to_json)

    doubtful = { features: [ { geometry: { coordinates: [ 1, 48 ] }, properties: { score: 0.3, city: "X" } } ] }.to_json
    assert_nil AddressGeocoder.parse(doubtful)
  end
end
