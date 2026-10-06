class User < ApplicationRecord
  # No public sign up: accounts come from invitations (admin → managers → members).
  # Password reset (:recoverable) comes with the emails step.
  devise :database_authenticatable, :rememberable, :validatable

  belongs_to :organization, optional: true

  # "manager" = responsable (manages the structure and its members), "member" = membre.
  enum :role, { member: "member", manager: "manager" }, validate: true

  validates :name, presence: true
  validates :organization, presence: true, unless: :admin?

  # Devise refuses the sign-in of a deactivated person, or of a person whose structure is deactivated.
  def active_for_authentication?
    super && deactivated_at.nil? && (organization.nil? || organization.active?)
  end

  # Message shown when the sign-in is refused (see devise.failure.deactivated).
  def inactive_message
    :deactivated
  end
end
