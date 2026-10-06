class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  # Email of the first manager, asked in the admin form "Nouvelle structure" (not stored on the structure).
  attr_accessor :manager_email

  validates :name, :address, presence: true
  validate :address_found

  # Finds the position of the address on the map (IGN), when it changes or isn't known yet.
  before_validation :geocode_address, if: -> { address.present? && (address_changed? || latitude.nil?) }
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

  def geocode_address
    @address_not_found = false
    result = AddressGeocoder.search(address)
    if result
      self.latitude, self.longitude, self.city = result.latitude, result.longitude, result.city
    else
      @address_not_found = true
    end
  rescue AddressGeocoder::Unavailable => error
    # The IGN can't be reached: the address is saved anyway, its position will be looked up at the next save.
    Rails.logger.warn("Geocoding unavailable: #{error.message}")
    self.latitude = self.longitude = nil
  end

  def address_found
    errors.add(:address, "est introuvable : vérifiez le numéro, la rue et la ville") if @address_not_found
  end

  def manager_email_not_taken
    errors.add(:manager_email, "a déjà un compte Glane") if User.exists?(email: manager_email.to_s.strip.downcase)
  end
end
