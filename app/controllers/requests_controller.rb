class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :update, :destroy]

  # GET /requests
  def index
    @requests = Request.all

    render json: @requests
  end

  # GET /requests/1
  def show
    render json: @request
  end

  # POST /requests
  def create
    @request = Request.new(request_params)

    if @request.save
      render json: @request, status: :created, location: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      # for accepted request, make the trip
      if @request.status == "accepted"
        to_driving_pref = @request.to_user.driving_pref
        from_driving_pref = @request.from_user.driving_pref
        if to_driving_pref > from_driving_pref
          driver = @request.to_user_id
        elsif to_driving_pref < from_driving_pref
          driver = @request.from_user_id
        else
          driver = @request.to_user_id
        end
        
        factory = RGeo::Cartesian.factory(:srid => 4326)
        to_points = Trip.find(@request.to_trip_id).waypoints
        from_points = Trip.find(@request.from_trip_id).waypoints
        to_times = Trip.find(@request.to_trip_id).waytimes
        from_times= Trip.find(@request.from_trip_id).waytimes
        if driver == @request.to_user_id
          waypoints = factory.multi_point([to_points[0], from_points[0], from_points[1], to_points[1]])
          waytimes = factory.multi_point([to_times[0], from_times[0], from_times[1], to_times[1]])
        else
          waypoints = factory.multi_point([from_points[0], to_points[0], to_points[1], from_points[1]])
          waytimes = factory.multi_point([from_times[0], to_times[0], to_times[1], from_times[1]])
        end
        @trip = Trip.create(
            waypoints: waypoints,
            waytimes: waytimes,
            to_work: Trip.find(@request.to_trip_id).to_work,
            order: [@request.to_user_id, @request.from_user_id],
            confirmed: [false, false],
            base_trips:[@request.to_trip_id, @request.from_trip_id]
            )
            
        p1 = Pool.create(user_id: @request.to_user_id, trip_id: @trip.id, is_active: false, is_pending: true)
        p2 = Pool.create(user_id: @request.from_user_id, trip_id: @trip.id, is_active: false, is_pending: true)
        
        if driver == @request.to_user_id
          p1.update(is_driver: true)
          p2.update(is_driver: false)
        else
          p2.update(is_driver: true)
          p1.update(is_driver: false)
        end
      end
      render json: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def request_params
      params.require(:request).permit(:from_user_id, :to_user_id, 
        :from_trip_id, :to_trip_id, :status)
    end
end