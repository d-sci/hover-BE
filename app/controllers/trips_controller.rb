class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy, :active_users]

  # GET /trips
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
      render json: @trip, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      render json: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end
  
  # GET /trips/1/active_users
  def active_users
    sql = "select u.* from users u join pools p on u.id = p.user_id where p.trip_id = :tid and p.is_active = true"
    vars = {tid: @trip.id}
    @active_users = User.find_by_sql [sql, vars]
    render json: @active_users
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trip_params
      params.require(:trip).permit(:waypoints, :waytimes, :to_work)
    end
end
