class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  validates :name, :address, presence: true

  def active?
    deactivated_at.nil?
  end
end
