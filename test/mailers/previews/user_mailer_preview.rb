# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # https://capstone-dasimons.c9users.io/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_code = User.new_code
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # https://capstone-dasimons.c9users.io/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_code = User.new_code
    UserMailer.password_reset
  end
end