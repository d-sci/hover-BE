# Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api#Zj5aJbp6h61ZVlCa.99

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password], 'authentication') 
    if command.success? 
      user = User.find_by_email(params[:email].downcase)
      render json: {message: "Succesfully authenticated. Here is your auth_token.", 
                    auth_token: command.result, user: UserSerializer.new(user) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def activate_account
    command = AuthenticateUser.call(params[:email], params[:code], 'activation') 
    if command.success?
      user = User.find_by_email(params[:email].downcase)
      user.activate
      render json: { message: "Succesfully activated account. Here is your auth_token. Please proceed to create a password.", 
                    auth_token: command.result,  user: UserSerializer.new(user) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def reset_password
    command = AuthenticateUser.call(params[:email], params[:code], 'reset') 
    if command.success? 
      user = User.find_by_email(params[:email].downcase)
      render json: { message: "Here is your auth_token. Please proceed to reset your password.", 
                    auth_token: command.result,  user: UserSerializer.new(user) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def register
    user = User.find_by_email(params[:email].downcase)
    if user && !user.activated
      user.create_activation_digest
      # user.send_activation_email    <-- to implement
      render json: {"message": "User found. Activation email sent (but actually not, here's your code)", 
                    "code": user.activation_code}
    elsif user
      render json: {"message":"User already activated. Did you forget your password?"}
    else
      render json: {"message":"User not found"}
    end
  end
  
  def forgot_password
    user = User.find_by_email(params[:email].downcase)
    if user && user.activated
      user.create_reset_digest
      # user.send_reset_email    <-- to implement
      render json: {"message": "User found. Reset email sent (but actually not, here's your code)", 
                    "code": user.reset_code}
    elsif user
      render json: {"message":"User has not been activated"}
    else
      render json: {"message":"User not found"}
    end
  end
  
end
