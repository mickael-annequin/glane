class Organization < ApplicationRecord
  include PickedAddress

  has_many :users, dependent: :restrict_with_error
  has_many :listings, dependent: :restrict_with_error
  has_many :reservations, dependent: :restrict_with_error # the listings this structure reserved

  # Email of the first manager, asked in the admin form "Nouvelle structure" (not stored on the structure).
  attr_accessor :manager_email

  validates :name, :address, presence: true
  validate :usual_schedule_valid
  validates :manager_email, presence: true, format: { with: Devise.email_regexp, allow_blank: true }, on: :create_with_manager
  validate :manager_email_not_taken, on: :create_with_manager

  scope :alphabetical, -> { order(:name) }

  def active?
    deactivated_at.nil?
  end

  # The usual opening hours, copied into each new listing (they can be changed listing by listing).
  def usual_opening_hours
    Schedule.new(usual_schedule)
  end

  # People who can use Glane: not deactivated, and not waiting for an invitation to be accepted.
  def active_members
    users.where(deactivated_at: nil).merge(User.without_pending_invitation)
  end

  private

  def usual_schedule_valid
    usual_opening_hours.errors.each { |message| errors.add(:usual_schedule, message) }
  end

  def manager_email_not_taken
    errors.add(:manager_email, "a déjà un compte Glane") if User.exists?(email: manager_email.to_s.strip.downcase)
  end
end
