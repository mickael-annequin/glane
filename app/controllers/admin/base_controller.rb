# Common to every page of the admin space: only the admin account can open them.
class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path, alert: "Cette page est réservée à l'administrateur." unless current_user.admin?
  end
end
