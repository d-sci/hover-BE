class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :avatar,
        :email, :phone, :gender, :company, :position, 
        :driving_pref, :car, :radio_stations, :talkativeness, :smoke, :ac
end
