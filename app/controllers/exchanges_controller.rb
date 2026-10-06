# "Mes échanges": for now the listings of my structure ("Dons"). Its reservations come with the reservation step.
class ExchangesController < ApplicationController
  def index
    organization = current_user.organization
    listings = organization ? organization.listings.includes(:category, :user).order(created_at: :desc).to_a : []
    # "En cours": online now. "Historique": withdrawn, or past their date.
    @current, @history = listings.partition { |listing| listing.available? && !listing.expired? }
  end
end
