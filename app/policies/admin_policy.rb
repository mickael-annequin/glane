# The admin space (app/controllers/admin): only the admin account. Checked with `authorize :admin, :access?`.
class AdminPolicy < ApplicationPolicy
  def access?
    user.admin?
  end
end
