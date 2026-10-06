class Category < ApplicationRecord
  has_many :category_opt_outs, dependent: :delete_all
  has_many :listings, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :icon, length: { maximum: 8 }
  validate :catch_all_stays_visible

  # Display order: by position, and the catch-all category ("Autres") always last.
  scope :ordered, -> { order(:catch_all, :position, :name) }
  scope :visible, -> { where(hidden: false) }

  before_create :place_at_the_end

  # Swaps the place of this category with the one just above (direction: :up) or below (:down).
  # "Autres" doesn't move: it is always last.
  def move(direction)
    return if catch_all?

    others = Category.where(catch_all: false).where.not(id: id)
    neighbour = if direction.to_s == "up"
      others.where(position: ...position).order(position: :desc).first
    else
      others.where("position > ?", position).order(:position).first
    end
    return unless neighbour

    Category.transaction do
      old_position = position
      update!(position: neighbour.position)
      neighbour.update!(position: old_position)
    end
  end

  private

  def place_at_the_end
    self.position = (Category.maximum(:position) || 0) + 1
  end

  def catch_all_stays_visible
    errors.add(:hidden, "« #{name} » ne peut pas être masquée : elle sert quand aucune autre catégorie ne convient") if catch_all? && hidden?
  end
end
