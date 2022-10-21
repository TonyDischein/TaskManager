class PasswordResetMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @token = @user.password_reset_token

    mail(to: @user.email, subject: 'Password reset')
  end
end
