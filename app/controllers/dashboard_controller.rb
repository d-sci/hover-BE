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
end
