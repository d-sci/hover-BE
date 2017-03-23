class MatchingController < ApplicationController
  
  def find_match
    @current_trip = Trip.find(params[:trip_id])
    if @current_trip.to_work
      origin_dist = 5000
      destination_dist = 1000
    else
      origin_dist = 1000
      destination_dist = 5000
    end
  
    sql = "select * from trips t join pools p on p.trip_id = t.id join users u on p.user_id = u.id
        where p.is_active = true and u.id != :uid and
            (u.driving_pref = 0 or u.driving_pref != :driving_pref) and t.to_work = :to_work and 
            ST_NumGeometries(t.waypoints) = 2 and
            ST_DWithin( ST_geometryN(t.waypoints, 1)::geography , :origin::geography, :origin_dist ) and
            ST_DWithin( ST_geometryN(t.waypoints, 2)::geography , :destination::geography, :destination_dist )
            limit 20"
    vars = {
      uid: @current_user.id, driving_pref: @current_user.driving_pref, to_work: @current_trip.to_work,
      origin: @current_trip.waypoints[0], destination: @current_trip.waypoints[1],
      origin_dist: origin_dist, destination_dist: destination_dist
      }
    
    # This gets up to 20 trips where (in order):
    # - the match user is actively taking this trip
    # - the match user isn't the current user
    # - the match user is neutral driving_pref or opposite of current user
    # - the match trip has same "to_work" value as current trip
    # - the match trip is currently an individual trip (technically not checking this, just checking that trip only has 2 waypoints)
    # - the match trip's origin is within [origin_dist] of the current trip's origin (note the difference in indexing!)
    # - the match trip's destination is [destination_dist] 1km of the current trip's destination
    
    # SHOULD HAVE SOME WAY OF RELAXING IF NOT ENOUGH RESULTS / BEING MORE PICKY IF TOO MANY.
    # ALSO TIMES NEVER CONSIDERED ANYWHERE
    # ALSO SHOULD PRIORITIZE EXISTING MATCHES SOMEWHERE SOMEHOW
    
    @matched_trips = Trip.find_by_sql [sql, vars]
    matches = []
    @matched_trips.each do |trip|
      @matched_user = trip.users.first
      @match = {trip: TripSerializer.new(trip), user_id: @matched_user.id, user_name: @matched_user.first_name, compat: compat(@current_user, @matched_user)}
      matches << @match
    end
    matches.sort_by!{|x| -x[:compat]}
    render json: matches
  end
    
  private
    def compat(u1, u2)
      #TODO
      Random.rand(50..100)
    end
end
