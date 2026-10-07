# "Membres": the managers of a structure invite people, name other managers and deactivate the ones who leave.
# Access rights: app/policies/user_policy.rb.
class MembersController < ApplicationController
  before_action :set_organization, only: %i[index create]
  before_action :set_member, except: %i[index create]

  def index
    # Active people first (managers, then members), deactivated ones at the end.
    @members = @organization.users.order(User.arel_table[:deactivated_at].asc.nulls_first, :role, :name, :email)
  end

  def create
    email = params[:email].to_s.strip.downcase

    if !email.match?(Devise.email_regexp)
      redirect_to members_path, alert: "Cet email n'est pas valide."
    elsif User.exists?(email: email)
      redirect_to members_path, alert: "#{email} a déjà un compte Glane."
    else
      User.invite!({ email: email, organization: @organization, role: :member }, current_user)
      redirect_to members_path, notice: "Invitation envoyée à #{email}."
    end
  end

  def promote
    @member.update!(role: :manager)
    redirect_to members_path, notice: "#{display_name} est maintenant responsable."
  end

  def demote
    @member.update!(role: :member)
    redirect_to members_path, notice: "#{display_name} n'est plus responsable."
  end

  def deactivate
    @member.update!(deactivated_at: Time.current)
    redirect_to members_path, notice: "#{display_name} est désactivé(e) : ce compte ne peut plus se connecter."
  end

  def reactivate
    @member.update!(deactivated_at: nil)
    redirect_to members_path, notice: "#{display_name} est réactivé(e)."
  end

  def resend_invitation
    @member.invite!(current_user) if @member.invitation_pending?
    redirect_to members_path, notice: "Invitation renvoyée à #{@member.email}."
  end

  private

  def set_organization
    authorize User
    @organization = current_user.organization
  end

  def set_member
    @member = authorize User.find(params[:id])
  end

  def display_name
    @member.name.presence || @member.email
  end
end
