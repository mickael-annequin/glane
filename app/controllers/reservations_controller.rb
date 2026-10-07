# Reserving a listing of another structure (docs/conception/wireframes.md, screen 6).
# Access rights: app/policies/reservation_policy.rb.
class ReservationsController < ApplicationController
  MAX_DAYS_AHEAD = 14

  before_action :set_listing, only: %i[new create]
  before_action :set_reservation, only: %i[cancel pick_up not_picked_up]

  def new
    @reservation = authorize @listing.reservations.new
  end

  def create
    @reservation = authorize @listing.reservations.new(organization: current_user.organization, user: current_user, pickup_at: chosen_pickup_at)

    if @reservation.book
      redirect_to @listing, notice: "C'est réservé ! Passage prévu #{helpers.pickup_label(@reservation.pickup_at)}."
    else
      render :new, status: :unprocessable_content
    end
  end

  def cancel
    @reservation.cancel!(by: current_user)
    redirect_to @reservation.listing, notice: "Réservation annulée : l'annonce est de nouveau proposée aux autres structures."
  end

  # The donor says the stock is gone…
  def pick_up
    @reservation.pick_up!
    redirect_to exchanges_path, notice: "C'est noté : « #{@reservation.listing.title} » est récupérée. Merci pour ce don !"
  end

  # …or that nobody came.
  def not_picked_up
    @reservation.not_picked_up!
    notice = if @reservation.listing.reservable?
      "C'est noté : « #{@reservation.listing.title} » est de nouveau proposée aux autres structures."
    else
      "C'est noté : « #{@reservation.listing.title} » n'a pas été récupérée, et sa date limite est passée."
    end
    redirect_to exchanges_path, notice: notice
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def set_reservation
    @reservation = authorize Reservation.find(params[:id])
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
