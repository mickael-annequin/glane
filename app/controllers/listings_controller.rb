# Access rights: app/policies/listing_policy.rb.
class ListingsController < ApplicationController
  before_action :set_listing, only: %i[show edit update withdraw]
  # The home page checks the rights with policy_scope (which listings I can see), not authorize.
  skip_after_action :verify_authorized, only: :index
  after_action :verify_policy_scoped, only: :index

  # Home page: the listings that can still be reserved, the most urgent first, filtered by category if asked.
  # As a list, or on a map (?view=map, and ?focus=<id> to center it on one listing).
  def index
    @view = params[:view] == "map" ? "map" : "list"
    @categories = Category.visible.ordered
    @category = @categories.find_by(id: params[:category])
    @listings = policy_scope(Listing).reservable.includes(:category, :organization).order(:available_until, created_at: :desc)
    @listings = @listings.where(category: @category) if @category
    @pickups_to_confirm = current_user.organization&.pickups_to_confirm || []
  end

  def show
    @reservation = @listing.active_reservation
  end

  # authorize first: Listing.new_from needs the person's structure.
  def new
    authorize Listing
    @listing = Listing.new_from(current_user)
  end

  def create
    authorize Listing
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

  def set_listing
    @listing = authorize Listing.find(params[:id])
  end

  def listing_params
    # photos: the photos kept (their signed id) and the new ones (uploaded files), see the form.
    permitted = params.require(:listing).permit(:category_id, :title, :available_until, :quantity, :unit, :storage,
                                                :address, :city, :latitude, :longitude, :availability_note, :description, photos: [])
    with_schedule(permitted, :schedule, params[:listing])
  end
end
