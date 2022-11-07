class PasswordResetNewForm
  include ActiveModel::Model

  attr_accessor(
    :email,
  )

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/ }
  validate :user_valid?

  def user
    User.find_by(email: email)
  end

  private

  def user_valid?
    errors.add(:email, I18n.t('password_reset.create.fail')) if user.blank?
  end
end
