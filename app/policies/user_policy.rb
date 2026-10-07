# "Membres": the managers of a structure manage its people, but never themselves:
# so a structure always keeps at least one active manager (the one using the page).
class UserPolicy < ApplicationPolicy
  def index?
    user.manager? && user.organization.present?
  end

  def create?
    index?
  end

  def resend_invitation?
    index? && record.organization_id == user.organization_id
  end

  def promote?
    resend_invitation? && record != user
  end

  def demote?
    promote?
  end

  def deactivate?
    promote?
  end

  def reactivate?
    promote?
  end
end
