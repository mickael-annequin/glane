# "Mes échanges": for now the listings of my structure ("Dons"). Its reservations come with the reservation step.
class ExchangesController < ApplicationController
  def index
    organization = current_user.organization
    listings = organization ? organization.listings.includes(:category, :user, active_reservation: %i[organization user]).order(created_at: :desc).to_a : []
    # "En cours": online now, or reserved. "Historique": withdrawn, picked up, or past their date.
    @current, @history = listings.partition { |listing| listing.reservable? || listing.reserved? }
  end
end
