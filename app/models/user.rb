class User < ApplicationRecord
  # No public sign up: accounts come from invitations (admin → managers → members).
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :organization, optional: true

  # "manager" = responsable (manages the structure and its members), "member" = membre.
  enum :role, { member: "member", manager: "manager" }, validate: true

  validates :name, presence: true

  scope :without_pending_invitation, -> { where(invitation_token: nil).or(where.not(invitation_accepted_at: nil)) }

  # Invited by email, but the person hasn't chosen their password yet.
  def invitation_pending?
    invitation_token.present? && invitation_accepted_at.nil?
  end
  validates :organization, presence: true, unless: :admin?

  def deactivated?
    deactivated_at.present? || organization&.active? == false
  end

  # Devise refuses the sign-in of a deactivated person, or of a person whose structure is deactivated.
  def active_for_authentication?
    super && !deactivated?
  end

  # Message shown when the sign-in is refused (see devise.failure.deactivated).
  def inactive_message
    deactivated? ? :deactivated : super
  end
end
