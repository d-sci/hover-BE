# Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api#Zj5aJbp6h61ZVlCa.99

class JsonWebToken 
  class << self 
    def encode(payload, exp = 20.years.from_now) 
      payload[:exp] = exp.to_i 
      JWT.encode(payload, Rails.application.secrets.secret_key_base) 
    end 
    
    def decode(token) 
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0] 
      HashWithIndifferentAccess.new body 
    rescue 
      nil 
    end
  end 
end
