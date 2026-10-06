module ListingsHelper
  # Short status of a listing, for its donor: "Disponible · avant le 30/11", "Retirée"…
  def listing_status(listing)
    if listing.expired?
      "Date limite dépassée le #{l(listing.available_until, format: :short)}"
    elsif listing.available?
      "Disponible · avant le #{l(listing.available_until, format: :short)}"
    elsif listing.withdrawn?
      "Retirée"
    elsif listing.reserved?
      "Réservée"
    else
      "Récupérée"
    end
  end

  # "avant demain", "avant jeudi 9 octobre"…
  def listing_deadline(listing)
    date = listing.available_until
    return "avant ce soir (aujourd'hui)" if date == Date.current
    return "avant demain soir" if date == Date.tomorrow

    "avant le #{l(date, format: :listing)}"
  end

  # "3 km", "moins d'1 km", or nil when a position is missing.
  def distance_label(from, to)
    distance = from&.distance_to(to)
    return if distance.nil?

    distance < 1 ? "moins d'1 km" : "#{distance.round} km"
  end

  # The deadline is close (today or tomorrow): shown in red.
  def urgent?(listing)
    listing.available_until <= Date.tomorrow
  end

  # Links to see the pickup place on a map, and to get there (opens Google Maps or Plans on the phone).
  def map_url(record)
    "https://www.openstreetmap.org/?mlat=#{record.latitude}&mlon=#{record.longitude}#map=17/#{record.latitude}/#{record.longitude}"
  end

  def directions_url(record)
    "https://www.google.com/maps/dir/?api=1&destination=#{record.latitude},#{record.longitude}"
  end
end
