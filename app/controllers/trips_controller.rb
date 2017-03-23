class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy, :active_users, :confirm]

  # GET /trips        <-- not necessary
  def index
    @trips = Trip.all

    render json: @trips
  end

  # GET /trips/1        
  def show
    render json: @trip
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      #also create the pool, and link to current user
      Pool.create(user_id: @current_user.id, trip_id: @trip.id, is_active: true)
      render json: @trip, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      n = @trip.confirmed.size
      @trip.update_columns(confirmed: [false]*n)
      render json: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/1   <-- not necessary?
  def destroy
    @trip.destroy
  end
  
  # GET /trips/1/confirm
  def confirm
    # this user confirms the trip
    u = @trip.order.index(@current_user.id)
    temp = @trip.confirmed
    temp[u] = true
    @trip.update_columns(confirmed: temp)
    
    # now check if they've both been confirmed since last edit
    # if so, can go ahead and make the trip live
    if @trip.confirmed.all?
      @trip.confirmed.size.times do |i|
        Pool.find_by_user_id_and_trip_id(@trip.order[i], @trip.base_trips[i]).update(is_active: false)
        Pool.find_by_user_id_and_trip_id(@trip.order[i], @trip.id).update(is_active: true, is_pending: false)
      end
    end
    render json: @trip
  end
  
  # GET /trips/1/active_users
  def active_users
    @active_users = @trip.users.where('pools.is_active': true)
    render json: @active_users
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trip_params
      params.require(:trip).permit(:waypoints, :waytimes, :to_work, :driver_id)
    end
end
