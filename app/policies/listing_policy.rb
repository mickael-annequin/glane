# Who can do what with a listing (an "annonce").
class ListingPolicy < ApplicationPolicy
  # Anyone can see a listing that can still be reserved; the donor structure can always see its own,
  # and the structure that reserved it can see it too.
  def show?
    record.reservable? || mine? || reserved_by_my_structure?
  end

  # Only the people of a structure publish (not the admin account, which has none).
  def create?
    user.organization.present?
  end

  # Only my structure's listings, and only while nobody reserved them.
  def update?
    mine? && record.available?
  end

  def withdraw?
    update?
  end

  # The listings I can see: the ones that can be reserved, my structure's, and the ones it reserved.
  class Scope < ApplicationPolicy::Scope
    def resolve
      reserved_by_my_structure = Reservation.active.where(organization_id: user.organization_id).select(:listing_id)
      scope.reservable.or(scope.where(organization_id: user.organization_id)).or(scope.where(id: reserved_by_my_structure))
    end
  end

  private

  def mine?
    user.organization_id.present? && record.organization_id == user.organization_id
  end

  def reserved_by_my_structure?
    reservation = record.active_reservation
    reservation.present? && reservation.organization_id == user.organization_id
  end
end
