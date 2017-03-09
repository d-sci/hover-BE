class UserMailer < ApplicationMailer

  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Hover account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Hover account password reset"
  end
end
