# Invites a manager in a structure (a new one, e.g. when the first manager left),
# or sends the invitation again to someone who hasn't accepted it yet.
class Admin::ManagerInvitationsController < Admin::BaseController
  def create
    organization = Organization.find(params[:organization_id])
    email = params[:email].to_s.strip.downcase
    person = User.find_by(email: email)

    if person && !(person.organization == organization && person.invitation_pending?)
      redirect_to edit_admin_organization_path(organization), alert: "#{email} a déjà un compte Glane."
    elsif email.match?(Devise.email_regexp)
      User.invite!({ email: email, organization: organization, role: :manager }, current_user)
      redirect_to edit_admin_organization_path(organization), notice: "Invitation envoyée à #{email}."
    else
      redirect_to edit_admin_organization_path(organization), alert: "Cet email n'est pas valide."
    end
  end
end
