class DashboardController < ApplicationController
 
  def active_carpools
    render json: {active_carpools: carpool_data(@current_user.active_carpools)}
  end
  
  def pending_carpools
    render json: {pending_carpools: carpool_data(@current_user.pending_carpools)}
  end

  def personal_trips
    render json: {personal_trips: ActiveModelSerializers::SerializableResource.new(@current_user.personal_trips, each_serializer: TripSerializer)}
  end
  
  def in_requests
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    render json: {in_requests: request_data(@in_requests, true)}
  end
  
  def out_requests
    @out_requests = @current_user.out_requests.order(:updated_at)
     render json: {out_requests: request_data(@out_requests, false)}
  end
  
  def full_dashboard
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    @out_requests = @current_user.out_requests.order(:updated_at)
    render json: {
      user: UserSerializer.new(@current_user),
      active_carpools: carpool_data(@current_user.active_carpools),
      pending_carpools: carpool_data(@current_user.pending_carpools),
      personal_trips: ActiveModelSerializers::SerializableResource.new(@current_user.personal_trips, each_serializer: TripSerializer),
      in_requests: request_data(@in_requests, true),
      out_requests: request_data(@out_requests, false)
    }
  end
  
  
  private
    # instead of more advanced serializer, get all data the API needs from the carpools here
    def carpool_data(carpools)
      data = []
      carpools.each do |t|
        @other_user = t.users.where.not(id: @current_user.id).first  #change remove ".first" to get all if allowing 3-4ppl trips
        @carpool = {
            trip: TripSerializer.new(t), 
            other_user: UserSerializer.new(@other_user), 
            iam_driver: t.driver_id == @current_user.id,
            driver_name: User.find(t.driver_id).first_name,
            compat: @current_user.compatibility(@other_user)
        }
        data << @carpool
      end
      return data
    end
    
    # instead of more advanced serializer, get all data the API needs from the requests here
    def request_data(requests, incoming)
      data = []
      requests.each do |r|
        if incoming
          @other_user = r.from_user
          @other_trip = Trip.find(r.from_trip_id)
          @my_trip = Trip.find(r.to_trip_id)
        else
          @other_user = r.to_user
          @other_trip = Trip.find(r.to_trip_id)
          @my_trip = Trip.find(r.from_trip_id)
        end
        @request = {
          id: r.id,
          other_user: UserSerializer.new(@other_user),
          other_trip: TripSerializer.new(@other_trip),
          my_trip: TripSerializer.new(@my_trip),
          compat: @current_user.compatibility(@other_user),
          status: r.status
        }
        data << @request
      end
      return data
    end
    
end