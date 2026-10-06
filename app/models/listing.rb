# A surplus published by a structure (the donor), that another structure can reserve.
class Listing < ApplicationRecord
  include PickedAddress

  # French labels, singular and plural ("1 carton", "12 cartons").
  UNITS = {
    "kg" => [ "kg", "kg" ], "liter" => [ "litre", "litres" ], "piece" => [ "pièce", "pièces" ],
    "box" => [ "carton", "cartons" ], "parcel" => [ "colis", "colis" ], "bag" => [ "sac", "sacs" ],
    "pallet" => [ "palette", "palettes" ]
  }.freeze
  STORAGES = { "ambient" => "Ambiant", "chilled" => "Frais", "frozen" => "Surgelé" }.freeze

  belongs_to :organization # the donor structure
  belongs_to :user         # the person who published
  belongs_to :category
  # Optional photos, only shown on the listing page (the list keeps the category icon).
  has_many_attached :photos
  has_many :reservations, dependent: :restrict_with_error
  has_one :active_reservation, -> { active }, class_name: "Reservation"

  enum :status, { available: "available", reserved: "reserved", picked_up: "picked_up", withdrawn: "withdrawn" }, validate: true

  validates :title, :available_until, :address, :availability, presence: true
  validates :title, length: { maximum: 80 }
  validates :unit, inclusion: { in: UNITS.keys }, allow_blank: true
  validates :storage, inclusion: { in: STORAGES.keys }, allow_blank: true
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :unit, presence: { message: "doit être choisie avec la quantité" }, if: -> { quantity.present? }
  validates :quantity, presence: { message: "doit être indiquée avec l'unité" }, if: -> { unit.present? }
  validate :available_until_not_in_the_past, if: -> { available_until.present? && (new_record? || available_until_changed?) }
  validate :category_offered, if: -> { category.present? && (new_record? || category_id_changed?) }
  validate :photos_are_small_images

  MAX_PHOTOS = 5
  MAX_PHOTO_SIZE = 10.megabytes # the limit of the free Cloudinary plan

  # Listings that other structures can still reserve: available, and not past their date.
  scope :reservable, -> { available.where(available_until: Date.current..) }

  # A new listing from this person: pickup place and availability copied from their structure.
  def self.new_from(user)
    organization = user.organization
    new(user: user, organization: organization, address: organization.address, city: organization.city,
        latitude: organization.latitude, longitude: organization.longitude,
        availability: organization.usual_availability, available_until: 7.days.from_now.to_date)
  end

  # Accepts "2,5" as well as "2.5" (French keyboards).
  def quantity=(value)
    super(value.is_a?(String) ? value.tr(",", ".") : value)
  end

  def expired?
    available? && available_until < Date.current
  end

  # Other structures can still reserve it.
  def reservable?
    available? && !expired?
  end

  # "25 kg", "1 carton", "2,5 litres", or nil when no quantity is given.
  def quantity_label
    return if quantity.blank?

    number = ActiveSupport::NumberHelper.number_to_rounded(quantity, precision: 2, strip_insignificant_zeros: true, separator: ",")
    singular, plural = UNITS.fetch(unit)
    "#{number} #{quantity > 1 ? plural : singular}"
  end

  def storage_label
    STORAGES[storage]
  end

  private

  def available_until_not_in_the_past
    errors.add(:available_until, "ne peut pas être dans le passé") if available_until < Date.current
  end

  def photos_are_small_images
    errors.add(:photos, "#{MAX_PHOTOS} au maximum") if photos.size > MAX_PHOTOS
    errors.add(:photos, "doivent être des images") unless photos.all? { |photo| photo.content_type.to_s.start_with?("image/") }
    errors.add(:photos, "ne doivent pas dépasser 10 Mo chacune") if photos.any? { |photo| photo.byte_size > MAX_PHOTO_SIZE }
  end

  def category_offered
    errors.add(:category, "n'est plus proposée : choisissez-en une autre") if category.hidden?
  end
end
