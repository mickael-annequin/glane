# Who can do what with a reservation: the structure that reserves (the beneficiary) and the donor structure.
class ReservationPolicy < ApplicationPolicy
  # A structure reserves the listing of another one, while it can still be reserved.
  def create?
    user.organization.present? && record.listing.organization_id != user.organization_id && record.listing.reservable?
  end

  # Both structures can cancel, while the reservation is active.
  def cancel?
    record.active? && (beneficiary? || donor?)
  end

  # Only the donor structure says the stock is gone, or that nobody came.
  def pick_up?
    record.active? && donor?
  end

  def not_picked_up?
    pick_up?
  end

  private

  def beneficiary?
    user.organization_id.present? && record.organization_id == user.organization_id
  end

  def donor?
    user.organization_id.present? && record.listing.organization_id == user.organization_id
  end
end
