class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :avatar,
        :email, :phone, :gender, :company, :position, 
        :driving_pref, :car, :radio_stations, :talkativeness, :smoke, :ac, :compat
  
  def avatar
    object.avatar.url
  end
  
  # include compatibility with current app user, when that info is provided
  def compat
    #if instance_options[:current_user]   #pass it in when doing Serializer.new()
      #return object.compatibility(instance_options[:current_user])
    if scope  #otherwise it's included by default in scope
      return object.compatibility(scope)
    else
      return 0
    end
  end
  
end
