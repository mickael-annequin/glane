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
    elsif (reservation = listing.picked_up_reservation)
      "Récupérée le #{l(reservation.closed_at.to_date, format: :short)} par #{reservation.organization.name}"
    else
      "Récupérée"
    end
  end

  # How a past reservation ended: "Annulée par le donateur le 07/10", "Récupérée le 08/10"…
  def reservation_status(reservation)
    date = l((reservation.closed_at || reservation.pickup_at).to_date, format: :short)
    if reservation.cancelled?
      reservation.cancelled_by_donor? ? "Annulée par le donateur le #{date}" : "Annulée par votre structure le #{date}"
    elsif reservation.picked_up?
      "Récupérée le #{date}"
    else
      "Non récupérée (#{date})"
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
    if listing.reservable?
      link_to "📍 Voir sur la carte", root_path(view: "map", focus: listing.id)
    else
      link_to "📍 Voir sur une carte", map_url(listing), target: "_blank", rel: "noopener"
    end
  end

  # "mardi 7 octobre à 14h", "aujourd'hui à 9h30"
  def pickup_label(time)
    day = if time.to_date == Date.current then "aujourd'hui"
    elsif time.to_date == Date.tomorrow then "demain"
    else l(time.to_date, format: :listing)
    end
    "#{day} à #{time.strftime("%-Hh%M").delete_suffix("00")}"
  end

  # The pickup times that can be chosen, day by day, from today to the deadline (2 weeks at most):
  # { "2026-10-07" => ["09:00", "09:15", …], … }. Only the opening hours of the listing, and not in the past.
  # A listing published before the planning existed has none: every day, from 7h to 21h.
  def pickup_times(listing)
    hours = listing.opening_hours
    last_day = [ listing.available_until, Date.current + ReservationsController::MAX_DAYS_AHEAD ].min
    (Date.current..last_day).each_with_object({}) do |day, result|
      times = hours.empty? ? Schedule::TIMES.select { |clock| clock.between?("07:00", "20:45") } : hours.times_on(day)
      times = times.select { |clock| Time.zone.parse("#{day} #{clock}") > Time.current } if day == Date.current
      result[day.iso8601] = times if times.any?
    end
  end

  # "Aujourd'hui", "Demain", "Mer 8"…
  def pickup_day_label(day)
    if day == Date.current then "Aujourd'hui"
    elsif day == Date.tomorrow then "Demain"
    else l(day, format: "%a %-d").capitalize
    end
  end

  # The opening hours and their note, one per line ("Du lundi au vendredi : 9h–12h et 14h–17h", "Sonner…").
  def availability_lines(schedule, note)
    [ (schedule.to_s unless schedule.empty?), note.presence ].compact
  end

  # Links to see the pickup place on a map, and to get there (opens Google Maps or Plans on the phone).
  def map_url(record)
    "https://www.openstreetmap.org/?mlat=#{record.latitude}&mlon=#{record.longitude}#map=17/#{record.latitude}/#{record.longitude}"
  end

  def directions_url(record)
    "https://www.google.com/maps/dir/?api=1&destination=#{record.latitude},#{record.longitude}"
  end
end
