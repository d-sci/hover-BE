class DashboardController < ApplicationController
 
  def active_carpools
    render json: @current_user.active_carpools
  end
  
  def pending_carpools
    render json: @current_user.pending_carpools
  end
  
  def personal_trips
    render json: @current_user.personal_trips
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
    @active_carpools = @current_user.active_carpools
    @pending_carpools = @current_user.pending_carpools
    @personal_trips = @current_user.personal_trips
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    @out_requests = @current_user.out_requests.order(:updated_at)
    render json: {
      user: UserSerializer.new(@current_user),
      active_carpools: ActiveModelSerializers::SerializableResource.new(@active_carpools, each_serializer: TripSerializer),
      pending_carpools: ActiveModelSerializers::SerializableResource.new(@pending_carpools, each_serializer: TripSerializer),
      personal_trips: ActiveModelSerializers::SerializableResource.new(@personal_trips, each_serializer: TripSerializer),
      in_requests: @in_requests,
      out_requests: @out_requests
    }
  end
end