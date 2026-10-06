require "net/http"

# Finds the position of a French address with the IGN "API Adresse" (free, no key):
# https://data.geopf.fr/geocodage/search?q=…
class AddressGeocoder
  URL = "https://data.geopf.fr/geocodage/search"
  # Below this score (0 to 1), the IGN isn't sure enough: the address is treated as not found.
  MIN_SCORE = 0.5

  Result = Data.define(:latitude, :longitude, :city, :label)
  class Unavailable < StandardError; end

  class << self
    # Tests use a fake search instead of the internet (see test/test_helper.rb).
    attr_accessor :fake

    # Returns a Result, or nil when the address is not found.
    # Raises Unavailable when the IGN can't be reached.
    def search(address)
      return fake.call(address) if fake

      uri = URI(URL)
      uri.query = URI.encode_www_form(q: address, limit: 1)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 3, read_timeout: 5) do |http|
        http.get(uri.request_uri)
      end
      raise Unavailable, "IGN answered #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      parse(response.body)
    rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, SystemCallError, OpenSSL::SSL::SSLError => error
      raise Unavailable, error.message
    end

    def parse(json)
      feature = JSON.parse(json).fetch("features").first
      return nil if feature.nil? || feature.dig("properties", "score").to_f < MIN_SCORE

      longitude, latitude = feature.dig("geometry", "coordinates")
      Result.new(latitude: latitude, longitude: longitude,
                 city: feature.dig("properties", "city"), label: feature.dig("properties", "label"))
    end
  end
end
