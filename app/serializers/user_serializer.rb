class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_type, :first_name, :last_name, :has_avatar,
        :email, :phone, :gender, :company, :position, :driving_pref,
        :car, :radio_stations, :talkativeness, :smoke, :ac
end
