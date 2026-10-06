class User < ApplicationRecord
  # No public sign up: accounts come from invitations (admin → managers → members).
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :organization, optional: true
  # The categories the person does NOT follow (by default, every category is followed).
  has_many :category_opt_outs, dependent: :delete_all
  has_many :listings, dependent: :restrict_with_error
  has_many :reservations, dependent: :restrict_with_error

  # "manager" = responsable (manages the structure and its members), "member" = membre.
  enum :role, { member: "member", manager: "manager" }, validate: true

  validates :name, presence: true

  scope :without_pending_invitation, -> { where(invitation_token: nil).or(where.not(invitation_accepted_at: nil)) }

  def followed_categories
    Category.visible.ordered.where.not(id: category_opt_outs.select(:category_id))
  end

  # Keeps only these categories followed (the boxes left checked in "Mon compte").
  def follow_only(category_ids)
    unfollowed_ids = Category.visible.where.not(id: Array(category_ids).compact_blank).pluck(:id)
    transaction do
      category_opt_outs.delete_all
      unfollowed_ids.each { |category_id| category_opt_outs.create!(category_id: category_id) }
    end
  end

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
