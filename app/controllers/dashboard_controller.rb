class DashboardController < ApplicationController
  def active_trips
    @active_trips = @current_user.trips.where('pools.is_active': true)
    render json: @active_trips
  end
  
  def pending_trips
    @pending_trips = @current_user.trips.where('pools.is_pending': true)
    render json: @pending_trips
  end
  
  def in_requests
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    render json: @in_requests
  end
  
  def out_requests
    @out_requests = @current_user.out_requests.order(:updated_at)
    render json: @out_requests
  end
  
  def full_dashboard
    @active_trips = @current_user.trips.where('pools.is_active': true)
    @pending_trips = @current_user.trips.where('pools.is_pending': true)
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    @out_requests = @current_user.out_requests.order(:updated_at)
    render json: {
      user: UserSerializer.new(@current_user),
      active_trips: ActiveModelSerializers::SerializableResource.new(@active_trips, each_serializer: TripSerializer),
      pending_trips: ActiveModelSerializers::SerializableResource.new(@pending_trips, each_serializer: TripSerializer),
      in_requests: @in_requests,
      out_requests: @out_requests
    }
  end
end