# A structure (the beneficiary) reserves a listing and says when it comes to pick it up.
class Reservation < ApplicationRecord
  ALREADY_TAKEN = "Cette annonce vient d'être réservée par une autre structure.".freeze

  belongs_to :listing
  belongs_to :organization                    # the beneficiary structure
  belongs_to :user                            # the person who reserved
  belongs_to :cancelled_by, class_name: "User", optional: true

  enum :status, { active: "active", picked_up: "picked_up", not_picked_up: "not_picked_up", cancelled: "cancelled" }, validate: true

  validates :pickup_at, presence: { message: "doit être choisi : un jour et une heure" }
  validate :pickup_slot_possible, on: :create, if: :pickup_at
  validate :not_my_own_listing, on: :create

  # Reserves the listing, if nobody else did it first. Returns true or false (see errors).
  def book
    return false unless valid?

    booked = listing.with_lock do # waits if another structure is reserving it at the same moment
      if listing.available? && !listing.expired?
        save!
        listing.reserved!
        true
      else
        false
      end
    end
    errors.add(:base, ALREADY_TAKEN) unless booked
    booked
  rescue ActiveRecord::RecordNotUnique
    errors.add(:base, ALREADY_TAKEN)
    false
  end

  # Cancelled by the donor or by the beneficiary: the listing can be reserved again.
  def cancel!(by:)
    transaction do
      update!(status: :cancelled, cancelled_by: by, closed_at: Time.current)
      listing.available!
    end
  end

  # The beneficiary came: the donor closes the reservation and the listing (they go to the history).
  def pick_up!
    transaction do
      update!(status: :picked_up, closed_at: Time.current)
      listing.picked_up!
    end
  end

  def cancelled_by_donor?
    cancelled? && cancelled_by&.organization_id == listing.organization_id
  end

  # Who to call on the other side: the person's phone, or else the one of their structure.
  def self.contact_phone(user)
    user.phone.presence || user.organization&.phone.presence
  end

  private

  def pickup_slot_possible
    if pickup_at < 5.minutes.ago
      errors.add(:pickup_at, "est déjà passé")
    elsif pickup_at.to_date > listing.available_until
      errors.add(:pickup_at, "doit être au plus tard le jour de la date limite")
    elsif !listing.opening_hours.empty? && !listing.opening_hours.includes?(pickup_at)
      errors.add(:pickup_at, "n'est pas dans les disponibilités du donateur")
    end
  end

  def not_my_own_listing
    errors.add(:base, "Vous ne pouvez pas réserver une annonce de votre structure.") if organization_id == listing&.organization_id
  end
end
