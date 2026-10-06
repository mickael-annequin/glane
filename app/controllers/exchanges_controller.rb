# "Mes échanges": the listings of my structure ("Dons") and the listings it reserved ("Réservations").
class ExchangesController < ApplicationController
  def index
    @tab = params[:tab] == "reservations" ? "reservations" : "donations"
    organization = current_user.organization

    listings = organization ? organization.listings.includes(:category, :user, active_reservation: %i[organization user]).order(created_at: :desc).to_a : []
    # "En cours": online now, or reserved. "Historique": withdrawn, picked up, or past their date.
    @current, @history = listings.partition { |listing| listing.reservable? || listing.reserved? }

    reservations = organization ? organization.reservations.includes(:user, :cancelled_by, listing: %i[category organization user]).order(pickup_at: :desc).to_a : []
    @current_reservations, @past_reservations = reservations.partition(&:active?)
    @current_reservations.sort_by!(&:pickup_at) # the next pickup first
  end
end
