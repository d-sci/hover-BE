class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :avatar,
        :email, :phone, :gender, :company, :position, 
        :driving_pref, :car, :radio_stations, :talkativeness, :smoke, :ac, :compat
  def avatar
    object.avatar.url
  end
  
  def compat
    object.compatibility(User.first) #pass in current user instead
  end
  
end
