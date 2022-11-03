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
      post :create, params: { password_reset_new_form: { email: user.email } }
    end

    user.reload

    assert_not_nil user.password_reset_token
    assert_not_nil user.password_reset_token_sent_at
    assert_response :redirect
  end

  test 'should get edit' do
    user = create(:user)
    user.set_password_reset_token

    get :edit, params: { token: user.password_reset_token }

    assert_response :success
  end

  test 'should post edit' do
    user = create(:user)
    user.set_password_reset_token
    token = user.password_reset_token
    new_password = (0...8).map { rand(65..90).chr }.join

    patch :update,
          params:
            { token: token,
              password_reset_edit_form: { password: new_password, password_confirmation: new_password, password_reset_token: token } }
    user.reload

    assert user.authenticate(new_password)
    assert_nil user.password_reset_token
    assert_nil user.password_reset_token_sent_at
    assert_redirected_to controller: :sessions, action: :new
  end
end
