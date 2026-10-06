# "Mes échanges": for now the listings of my structure ("Dons"). Its reservations come with the reservation step.
class ExchangesController < ApplicationController
  def index
    organization = current_user.organization
    @listings = organization ? organization.listings.includes(:category, :user).order(created_at: :desc) : Listing.none
  end
end
