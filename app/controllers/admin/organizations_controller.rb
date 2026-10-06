class Admin::OrganizationsController < Admin::BaseController
  before_action :set_organization, only: %i[edit update deactivate reactivate]

  def index
    @organizations = Organization.alphabetical.includes(:users)
  end

  def new
    @organization = Organization.new
  end

  # Creates the structure and invites its first manager by email, together:
  # if the invitation can't be sent, the structure isn't created either.
  def create
    @organization = Organization.new(organization_params)

    if @organization.valid?(:create_with_manager)
      Organization.transaction do
        @organization.save!
        User.invite!({ email: @organization.manager_email, organization: @organization, role: :manager }, current_user)
      end
      redirect_to admin_organizations_path, notice: "Structure créée. Une invitation a été envoyée à #{@organization.manager_email}."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @organization.update(organization_params.except(:manager_email))
      redirect_to admin_organizations_path, notice: "Structure modifiée."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def deactivate
    @organization.update!(deactivated_at: Time.current)
    redirect_to edit_admin_organization_path(@organization), notice: "Structure désactivée : ses membres ne peuvent plus se connecter."
  end

  def reactivate
    @organization.update!(deactivated_at: nil)
    redirect_to edit_admin_organization_path(@organization), notice: "Structure réactivée."
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :address, :latitude, :longitude, :city, :phone, :manager_email)
  end
end
