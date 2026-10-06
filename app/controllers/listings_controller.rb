class ListingsController < ApplicationController
  before_action :require_organization, except: %i[index show]
  before_action :set_own_listing, only: %i[edit update withdraw]
  before_action :require_available, only: %i[edit update withdraw]

  # Home page: the listings that can still be reserved, the most urgent first, filtered by category if asked.
  def index
    @categories = Category.visible.ordered
    @category = @categories.find_by(id: params[:category])
    @listings = Listing.reservable.includes(:category, :organization).order(:available_until, created_at: :desc)
    @listings = @listings.where(category: @category) if @category
  end

  # Anyone can see a listing that can still be reserved; the donor structure can always see its own.
  def show
    @listing = Listing.find(params[:id])
    return if mine?(@listing) || (@listing.available? && !@listing.expired?)

    redirect_to root_path, alert: "Cette annonce n'est plus disponible."
  end

  def new
    @listing = Listing.new_from(current_user)
  end

  def create
    @listing = Listing.new_from(current_user)
    @listing.assign_attributes(listing_params)

    if @listing.save
      redirect_to @listing, notice: "Votre annonce est en ligne."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: "Annonce modifiée."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def withdraw
    @listing.withdrawn!
    redirect_to exchanges_path, notice: "Annonce « #{@listing.title} » retirée."
  end

  private

  def require_organization
    redirect_to organization_path, alert: "Seules les structures peuvent publier des annonces." if current_user.organization.nil?
  end

  # Only the listings of my structure: any other one is "not found".
  def set_own_listing
    @listing = current_user.organization.listings.find(params[:id])
  end

  # A reserved, picked up or withdrawn listing can't change any more.
  def require_available
    redirect_to @listing, alert: "Cette annonce n'est plus modifiable." unless @listing.available?
  end

  def mine?(listing)
    listing.organization_id == current_user.organization_id
  end

  def listing_params
    # photos: the photos kept (their signed id) and the new ones (uploaded files), see the form.
    params.require(:listing).permit(:category_id, :title, :available_until, :quantity, :unit, :storage,
                                    :address, :city, :latitude, :longitude, :availability, :description, photos: [])
  end
end
