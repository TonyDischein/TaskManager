class Web::PasswordResetsController < Web::ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new; end

  def create
    user = User.find_by(email: params['password_reset'][:email])

    if user.present?
      user.set_password_reset_token

      PasswordResetMailer.with({ user: user }).reset_password.deliver_now
    end

    redirect_to(new_session_path, flash: { success: t('password_reset.create.success') })
  end

  def edit; end

  def update
    if @user.update(password_params)

      redirect_to(new_session_path, flash: { success: t('password_reset.update.success') })
    else
      render(:edit)
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(password_reset_token: params[:token])

    redirect_to(new_session_path, flash: { warning: t('password_reset.update.fail') }) unless @user&.password_reset_period_valid?
  end
end
