class UserSerializer < ActiveModel::Serializer
  attributes :id, :type, :first_name, :last_name, 
        :email, :phone, :gender, :company, :position, 
        :office_lat, :office_lon, :home_lat, :home_lon, :times,
        :radio_stations, :talkativeness, :smoke, :ac
end
