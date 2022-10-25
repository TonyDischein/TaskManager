class Web::PasswordResetsController < Web::ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
    @password_reset_new = PasswordResetNewForm.new
  end

  def create
    @password_reset_new = PasswordResetNewForm.new(password_reset_new_params)

    if @password_reset_new.valid?
      @password_reset_new.user.set_password_reset_token

<<<<<<< HEAD
      PasswordResetMailer.with({ user: @password_reset_new.user }).reset_password.deliver_later
=======
      SendResetPasswordJob.perform_async(user.id)
>>>>>>> Add mailer jobs
    end

    redirect_to(new_session_path, flash: { success: t('password_reset.create.success') })
  end

  def edit
    @password_reset_edit = PasswordResetEditForm.new
  end

  def update
    @password_reset_edit = PasswordResetEditForm.new(password_reset_edit_params)

    if @password_reset_edit.update
      redirect_to(new_session_path, flash: { success: t('password_reset.update.success') })
    else
      render(:edit)
    end
  end

  private

  def password_reset_new_params
    params.require(:password_reset_new_form).permit(:email)
  end

  def password_reset_edit_params
    params.require(:password_reset_edit_form).permit(:password, :password_confirmation, :password_reset_token)
  end

  def set_user
    @user = User.find_by(password_reset_token: params[:token])

    redirect_to(new_session_path, flash: { warning: t('password_reset.update.fail') }) unless @user&.password_reset_period_valid?
  end
end
