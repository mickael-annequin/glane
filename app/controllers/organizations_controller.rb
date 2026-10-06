# "Ma structure": the structure of the signed-in person. Only its managers can edit it.
class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[edit update]
  before_action :require_manager, only: %i[edit update]

  def show
    @organization = current_user.organization
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      redirect_to organization_path, notice: "Fiche de la structure enregistrée."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_organization
    @organization = current_user.organization
    redirect_to organization_path if @organization.nil?
  end

  def require_manager
    redirect_to organization_path, alert: "Seuls les responsables peuvent modifier la fiche de la structure." unless current_user.manager?
  end

  def organization_params
    params.require(:organization).permit(:name, :address, :phone, :usual_availability)
  end
end
