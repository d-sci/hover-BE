class DashboardController < ApplicationController
 
  def active_carpools
    @active_carpools = @current_user.active_carpools
    render json: {active_carpools: ActiveModelSerializers::SerializableResource.new(@active_carpools, each_serializer: TripSerializer, scope: @current_user)}
  end
  
  def pending_carpools
    @pending_carpools = @current_user.pending_carpools
    render json: {pending_carpools: ActiveModelSerializers::SerializableResource.new(@pending_carpools, each_serializer: TripSerializer, scope: @current_user)}
  end

  def personal_trips
    @personal_trips = @current_user.personal_trips
    render json: {personal_trips: ActiveModelSerializers::SerializableResource.new(@personal_trips, each_serializer: TripSerializer, scope: @current_user)}
  end
  
  def in_requests
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    render json: {in_requests: ActiveModelSerializers::SerializableResource.new(@in_requests, each_serializer: RequestSerializer, scope: @current_user)}
  end
  
  def out_requests
    @out_requests = @current_user.out_requests.order(:updated_at)
    render json: {out_requests: ActiveModelSerializers::SerializableResource.new(@out_requests, each_serializer: RequestSerializer, scope: @current_user)}
  end
  
  def full_dashboard
    @active_carpools = @current_user.active_carpools
    @pending_carpools = @current_user.pending_carpools
    @personal_trips = @current_user.personal_trips
    @in_requests = @current_user.in_requests.where(status: 'pending').order(:updated_at)
    @out_requests = @current_user.out_requests.order(:updated_at)
    render json: {
      user: UserSerializer.new(@current_user),
      active_carpools: ActiveModelSerializers::SerializableResource.new(@active_carpools, each_serializer: TripSerializer, scope: @current_user),
      pending_carpools: ActiveModelSerializers::SerializableResource.new(@pending_carpools, each_serializer: TripSerializer, scope: @current_user),
      personal_trips: ActiveModelSerializers::SerializableResource.new(@personal_trips, each_serializer: TripSerializer, scope: @current_user),
      in_requests: ActiveModelSerializers::SerializableResource.new(@in_requests, each_serializer: RequestSerializer, scope: @current_user),
      out_requests: ActiveModelSerializers::SerializableResource.new(@out_requests, each_serializer: RequestSerializer, scope: @current_user)
    }
  end

    
end