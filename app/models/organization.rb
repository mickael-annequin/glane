class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  # Email of the first manager, asked in the admin form "Nouvelle structure" (not stored on the structure).
  attr_accessor :manager_email

  validates :name, :address, presence: true
  # The address is picked in the IGN suggestions (address_autocomplete_controller.js), which also give its
  # position: an address typed without picking a suggestion has no position, and is refused.
  validate :address_picked, if: -> { address.present? && (new_record? || address_changed?) }
  validates :manager_email, presence: true, format: { with: Devise.email_regexp, allow_blank: true }, on: :create_with_manager
  validate :manager_email_not_taken, on: :create_with_manager

  scope :alphabetical, -> { order(:name) }

  def active?
    deactivated_at.nil?
  end

  # People who can use Glane: not deactivated, and not waiting for an invitation to be accepted.
  def active_members
    users.where(deactivated_at: nil).merge(User.without_pending_invitation)
  end

  def located?
    latitude.present? && longitude.present?
  end

  private

  def address_picked
    return if located? && latitude_changed?

    errors.add(:address, "doit être choisie dans la liste des suggestions qui s'affiche pendant la saisie")
  end

  def manager_email_not_taken
    errors.add(:manager_email, "a déjà un compte Glane") if User.exists?(email: manager_email.to_s.strip.downcase)
  end
end
