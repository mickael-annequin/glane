# "Ma structure": only its managers edit it.
class OrganizationPolicy < ApplicationPolicy
  def update?
    user.manager? && record == user.organization
  end
end
