# An address picked in the IGN suggestions (app/views/shared/_address_field.html.erb), which also give
# its position (latitude, longitude) and city. Used by the structures and by the listings (pickup place).
# An address typed without picking a suggestion has no new position, and is refused.
module PickedAddress
  extend ActiveSupport::Concern

  included do
    validate :address_picked, if: -> { address.present? && (new_record? || address_changed?) }
  end

  def located?
    latitude.present? && longitude.present?
  end

  # Straight-line distance in km to another place with a position (haversine formula), or nil.
  def distance_to(other)
    return unless located? && other&.located?

    radians = ->(degrees) { degrees * Math::PI / 180 }
    d_lat = radians.(other.latitude - latitude)
    d_lon = radians.(other.longitude - longitude)
    a = Math.sin(d_lat / 2)**2 + Math.cos(radians.(latitude)) * Math.cos(radians.(other.latitude)) * Math.sin(d_lon / 2)**2
    6371 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end

  private

  def address_picked
    return if located? && latitude_changed?

    errors.add(:address, "doit être choisie dans la liste des suggestions qui s'affiche pendant la saisie")
  end
end
