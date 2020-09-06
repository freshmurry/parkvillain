class SpacesController < ApplicationController
  before_action :set_space, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show, :preload, :preview]
  before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]
  
  def index
    @spaces = current_user.spaces
  end

  def new
    @space = current_user.spaces.build
  end

  def create
    # This code makes host register with Stripe first. We want people to create their listing without having to signup with Stripe first.
    # if !current_user.is_active_host
    #   return redirect_to payout_path, alert: "Please Connect to Stripe Express first."
    # end
    
    @space = current_user.spaces.build(space_params)
    if @space.save
      redirect_to listing_space_path(@space), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong..."
      render :new
    end
  end

  def show
    @photos = @space.photos
    @guest_reviews = Review.where(type: "GuestReview")
  end
  
  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @space.photos
  end

  def amenities
  end

  def location
  end

  def update
    new_params = space_params
    new_params = space_params.merge(active: true) if is_ready_space

    if @space.update(new_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
    # redirect_to space_path(@space), notice: "Saved..."
  end
  
  #---- RESERVATIONS ----
  def preload
    today = Date.today
    reservations = @space.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    unavailable_dates = @space.calendars.where("status = ? AND day > ?", 1, today)

    special_dates = @space.calendars.where("status = ? AND day > ? AND price <> ?", 0, today, @space.price)
    
    render json: {
      reservations: reservations,
      unavailable_dates: unavailable_dates,
      special_dates: special_dates
    }
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @space)
    }

    render json: output
  end
  
  private
    def is_conflict(start_date, end_date, space)
      check = space.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check_2 = space.calendars.where("day BETWEEN ? AND ? AND status = ?", start_date, end_date, 1).limit(1)
      
      check.size > 0 || check_2.size > 0 ? true : false 
    end
    
    def set_space
      @space = Space.find(params[:id])
    end

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @space.user_id
    end

    def is_ready_space
      !@space.active && !@space.price.blank? && !@space.listing_name.blank? && !@space.photos.blank? && !@space.address.blank?
    end

    def space_params
      params.require(:space).permit(:space_type, :listing_name, :description, :address, :handi_accessible, :surveillance, 
      :electric_space, :is_unheated_space, :is_heated_space, :is_elevator, :is_parking_attendant, :is_stairs, :price, :active, :instant)
    end
end