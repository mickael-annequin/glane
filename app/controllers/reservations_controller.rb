# Reserving a listing of another structure (docs/conception/wireframes.md, screen 6).
class ReservationsController < ApplicationController
  MAX_DAYS_AHEAD = 14

  before_action :set_listing, only: %i[new create]
  before_action :require_reservable, only: %i[new create]

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

  # Only the two structures of the reservation can cancel it.
  def cancel
    my_organization_id = current_user.organization_id
    reservation = Reservation.active.joins(:listing)
                             .where(organization_id: my_organization_id).or(Reservation.active.joins(:listing).where(listings: { organization_id: my_organization_id }))
                             .find(params[:id])
    reservation.cancel!(by: current_user)
    redirect_to reservation.listing, notice: "Réservation annulée : l'annonce est de nouveau proposée aux autres structures."
  end

  # Only the donor structure says the stock is gone.
  def pick_up
    reservation = Reservation.active.joins(:listing).where(listings: { organization_id: current_user.organization_id }).find(params[:id])
    reservation.pick_up!
    redirect_to exchanges_path, notice: "C'est noté : « #{reservation.listing.title} » est récupérée. Merci pour ce don !"
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
    return if day.blank? || !Schedule::TIMES.include?(hour)

    Time.zone.parse("#{day} #{hour}")
  rescue ArgumentError
    nil
  end
end
