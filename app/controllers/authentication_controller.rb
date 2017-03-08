# Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api#Zj5aJbp6h61ZVlCa.99

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  
  def login
    command = AuthenticateUser.call(params[:email], params[:password], 'login') 
    if command.success? 
      user = User.find_by_email(params[:email])
      render json: {message: "Succesfully logged in. Here is your auth_token", 
                    auth_token: command.result, user: UserSerializer.new(user) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def account_activation
    command = AuthenticateUser.call(params[:email], params[:code], 'activation') 
    if command.success?
      user = User.find_by_email(params[:email])
      user.activate
      render json: { message: "Succesfully activated account. Here is your auth_token. Please proceed to set a password", 
                    auth_token: command.result,  user: UserSerializer.new(user) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def password_reset
    command = AuthenticateUser.call(params[:email], params[:code], 'reset') 
    if command.success? 
      user = User.find_by_email(params[:email])
      render json: { message: "Here is your auth_token. Please proceed to reset your password", 
                    auth_token: command.result,  user: UserSerializer.new(user) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
end
