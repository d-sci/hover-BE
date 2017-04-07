class MatchingController < ApplicationController
  
  def find_match
    @current_trip = Trip.find(params[:trip_id])
    render json: @current_user.matches(@current_trip)
  end
    
end
