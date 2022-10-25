class SendResetPasswordJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer

  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.blank?

    PasswordResetMailer.with(user: user).reset_password.deliver_now
  end
end
