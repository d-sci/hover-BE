# Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api#Zj5aJbp6h61ZVlCa.99

class AuthenticateUser 
  prepend SimpleCommand 
  
  def initialize(email, code_or_password, action) 
    @email = email.downcase 
    @code_or_password = code_or_password
    @action = action
  end 
  
  def call 
    JsonWebToken.encode(user_id: user.id) if user 
  end 
  
  private 
  
  attr_accessor :email, :code_or_password, :action 
  
  def user 
    user = User.find_by_email(email)
    if action == 'authentication'
      return user if user && user.authenticate(code_or_password)
    else
      return user if user && user.authenticate_by_code(action, code_or_password)
    end
    
    errors.add :user_authentication, 'invalid credentials' 
    nil 
  end 
  
end