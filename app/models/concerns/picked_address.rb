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

  private

  def address_picked
    return if located? && latitude_changed?

    errors.add(:address, "doit être choisie dans la liste des suggestions qui s'affiche pendant la saisie")
  end
end
