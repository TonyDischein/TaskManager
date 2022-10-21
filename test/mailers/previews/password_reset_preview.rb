class PasswordResetPreview < ActionMailer::Preview
  def reset_password
    @user = User.first
    @user.set_password_reset_token

    PasswordResetMailer.with(user: @user).reset_password
  end
end
