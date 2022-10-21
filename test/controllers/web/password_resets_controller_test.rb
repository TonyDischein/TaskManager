require 'test_helper'

class Web::PasswordResetsControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    user = create(:user)

    assert_nil user.password_reset_token
    assert_nil user.password_reset_token_sent_at

    assert_emails 1 do
      post :create, params: { password_reset: { email: user.email } }
    end

    user.reload

    assert_not_nil user.password_reset_token
    assert_not_nil user.password_reset_token_sent_at
    assert_response :redirect
  end

  test 'should get edit' do
    user = create(:user)
    post :create, params: { password_reset: { email: user.email } }
    user.reload

    get :edit, params: { token: user.password_reset_token }
    assert_response :success
  end

  test 'should post edit' do
    user = create(:user)
    post :create, params: { password_reset: { email: user.email } }
    user.reload

    password = (0...8).map { rand(65..90).chr }.join

    patch :update, params: { token: user.password_reset_token, user: { password: password, password_confirmation: password } }

    assert_response :redirect
  end
end
