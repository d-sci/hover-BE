class DashboardController < ApplicationController
 
  def active_carpools
    render json: {active_carpools: ActiveModelSerializers::SerializableResource.new(@current_user.active_carpools, each_serializer: TripSerializer)}
  end
  
  def pending_carpools
    render json: {pending_carpools: ActiveModelSerializers::SerializableResource.new(@current_user.pending_carpools, each_serializer: TripSerializer)}
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
      active_carpools: ActiveModelSerializers::SerializableResource.new(@current_user.active_carpools, each_serializer: TripSerializer),
      pending_carpools: ActiveModelSerializers::SerializableResource.new(@current_user.pending_carpools, each_serializer: TripSerializer),
      personal_trips: ActiveModelSerializers::SerializableResource.new(@current_user.personal_trips, each_serializer: TripSerializer),
      in_requests: request_data(@in_requests, true),
      out_requests: request_data(@out_requests, false)
    }
  end
  
  
  private
    # instead of more advanced serializer, get all data the API needs from the requests here
    def request_data(requests, incoming)
      data = []
      requests.each do |r|
        if incoming
          @other_trip = Trip.find(r.from_trip_id)
          @my_trip = Trip.find(r.to_trip_id)
        else
          @other_trip = Trip.find(r.to_trip_id)
          @my_trip = Trip.find(r.from_trip_id)
        end
        @request = {
          id: r.id,
          status: r.status,
          other_trip: TripSerializer.new(@other_trip),
          my_trip: TripSerializer.new(@my_trip)
        }
        data << @request
      end
      return data
    end
    
end