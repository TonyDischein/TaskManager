require 'test_helper'

class PasswordResetMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  test 'reset password' do
    user = create(:user)
    user.set_password_reset_token
    token_path = edit_password_reset_url(token: user.password_reset_token, only_path: true)

    params = { user: user }

    email = PasswordResetMailer.with(params).reset_password

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ENV['MAILER_USERNAME']], email.from
    assert_equal [user.email], email.to
    assert_equal 'Password reset', email.subject
    assert email.body.to_s.include?("Dear, #{user.first_name}")
    assert email.body.to_s.include?(token_path)
  end
end
