class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :avatar,
        :email, :phone, :gender, :company, :position, 
        :driving_pref, :car, :radio_stations, :talkativeness, :smoke, :ac, :compat
  
  def avatar
    object.avatar.url
  end
  
  # include compatibility with current app user, which is "scope"
  # --> render json: @xxx  passes in @current_user to scope automatically
  # --> render json: {xxx: Serializer.new(@xxx)} doesn't, need to say render json: {xxx: Serializer.new(@xxx, scope: @current_user)}
  # --> if somehow not included, fallback to 0
  def compat
    scope ? object.compatibility(scope) : 0
  end
  
end
