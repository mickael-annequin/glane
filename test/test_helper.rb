ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# No internet in tests: addresses are "found" in Chartres, except the ones containing "introuvable".
AddressGeocoder.fake = lambda do |address|
  next nil if address.include?("introuvable")

  AddressGeocoder::Result.new(latitude: 48.4469, longitude: 1.4890, city: "Chartres", label: address)
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Simulates an IGN outage during the block.
    def with_geocoding_unavailable
      previous = AddressGeocoder.fake
      AddressGeocoder.fake = ->(_address) { raise AddressGeocoder::Unavailable, "test" }
      yield
    ensure
      AddressGeocoder.fake = previous
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end
