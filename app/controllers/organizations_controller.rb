# "Ma structure": the structure of the signed-in person. Only its managers can edit it (app/policies/organization_policy.rb).
class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[edit update]
  skip_after_action :verify_authorized, only: :show # everyone sees their own structure

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

  # The admin account has no structure: back to its "Ma structure" page.
  def set_organization
    @organization = current_user.organization
    if @organization
      authorize @organization
    else
      redirect_to organization_path
    end
  end

  def organization_params
    permitted = params.require(:organization).permit(:name, :address, :latitude, :longitude, :city, :phone, :usual_availability_note)
    with_schedule(permitted, :usual_schedule, params[:organization])
  end
end
