# Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api#Zj5aJbp6h61ZVlCa.99

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  
  def login
    command = AuthenticateUser.call(params[:email], params[:password], 'login') 
    if command.success? 
      render json: { auth_token: command.result, user: User.find_by_email(params[:email]) }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def account_activation
    command = AuthenticateUser.call(params[:email], params[:code], 'activation') 
    if command.success? 
      render json: { auth_token: command.result, debug: "Account Activation" }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
  def password_reset
    command = AuthenticateUser.call(params[:email], params[:code], 'reset') 
    if command.success? 
      render json: { auth_token: command.result, debug: "Password Reset" }
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
  
end
