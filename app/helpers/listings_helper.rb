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

  # Address of a listing photo. Online the photos are on Cloudinary, which resizes them on the fly;
  # on the developer's computer and in tests they are files on disk, shown as they are.
  def photo_url(photo, **transformation)
    if photo.blob.service_name == "cloudinary"
      cl_image_path(photo.key, quality: :auto, fetch_format: :auto, **transformation)
    else
      url_for(photo)
    end
  end

  # The listings grouped by pickup place, for the map: one marker per place, even with several listings there.
  def map_places(listings, organization)
    listings.group_by { |listing| [ listing.latitude.round(5), listing.longitude.round(5) ] }.map do |(latitude, longitude), here|
      {
        latitude: latitude, longitude: longitude, icon: here.first.category.icon.presence || "📦", count: here.size,
        listings: here.map do |listing|
          { id: listing.id, title: listing.title, icon: listing.category.icon.presence || "📦", url: listing_path(listing),
            details: [ listing.quantity_label, listing.city, distance_label(organization, listing) ].compact.join(" · "),
            deadline: listing_deadline(listing), urgent: urgent?(listing), mine: listing.organization_id == organization&.id }
        end
      }
    end
  end

  # "📍 Voir sur la carte": our map centered on the listing when it's on it, an OpenStreetMap page otherwise.
  def listing_map_link(listing)
    if listing.available? && !listing.expired?
      link_to "📍 Voir sur la carte", root_path(view: "map", focus: listing.id)
    else
      link_to "📍 Voir sur une carte", map_url(listing), target: "_blank", rel: "noopener"
    end
  end

  # Links to see the pickup place on a map, and to get there (opens Google Maps or Plans on the phone).
  def map_url(record)
    "https://www.openstreetmap.org/?mlat=#{record.latitude}&mlon=#{record.longitude}#map=17/#{record.latitude}/#{record.longitude}"
  end

  def directions_url(record)
    "https://www.google.com/maps/dir/?api=1&destination=#{record.latitude},#{record.longitude}"
  end
end
