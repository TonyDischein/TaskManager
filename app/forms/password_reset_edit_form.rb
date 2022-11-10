class PasswordResetEditForm
  include ActiveModel::Model

  attr_accessor(
    :password,
    :password_confirmation,
    :password_reset_token,
  )

  validates :password, :password_confirmation, presence: true
  validates :password, confirmation: true
  validate :user_valid?

  def user
    User.find_by(password_reset_token: password_reset_token)
  end

  private

  def user_valid?
    errors.add(:base, I18n.t('password_reset.update.fail')) if user.blank?
  end
end
