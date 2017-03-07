class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_type, :first_name, :last_name, 
        :email, :phone, :gender, :company, :position, 
        :car, :radio_stations, :talkativeness, :smoke, :ac
end
