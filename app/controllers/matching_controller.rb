class MatchingController < ApplicationController
  
  def find_match
    @current_trip = Trip.find(params[:trip_id])
    @matches = @current_user.matches(@current_trip)
    render json: {matches: ActiveModelSerializers::SerializableResource.new(@matches, each_serializer: TripSerializer, scope: @current_user)}
  end
    
end
