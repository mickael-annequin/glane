# Reserving a listing of another structure (docs/conception/wireframes.md, screen 6).
class ReservationsController < ApplicationController
  PICKUP_HOURS = (7..20).flat_map { |hour| [ format("%02d:00", hour), format("%02d:30", hour) ] }.freeze
  MAX_DAYS_AHEAD = 14

  before_action :set_listing
  before_action :require_reservable

  def new
    @reservation = @listing.reservations.new
  end

  def create
    @reservation = @listing.reservations.new(organization: current_user.organization, user: current_user, pickup_at: chosen_pickup_at)

    if @reservation.book
      redirect_to @listing, notice: "C'est réservé ! Passage prévu #{helpers.pickup_label(@reservation.pickup_at)}."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def require_reservable
    if current_user.organization.nil?
      redirect_to @listing, alert: "Seules les structures peuvent réserver."
    elsif @listing.organization_id == current_user.organization_id
      redirect_to @listing, alert: "Vous ne pouvez pas réserver une annonce de votre structure."
    elsif !@listing.reservable?
      redirect_to root_path, alert: "Cette annonce n'est plus disponible."
    end
  end

  # The day and the hour chosen in the form, as a time in Paris (nil if one is missing or wrong).
  def chosen_pickup_at
    day = params.dig(:reservation, :pickup_day)
    hour = params.dig(:reservation, :pickup_hour)
    return if day.blank? || !PICKUP_HOURS.include?(hour)

    Time.zone.parse("#{day} #{hour}")
  rescue ArgumentError
    nil
  end
end
