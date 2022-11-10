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

  def update
    return false if invalid?

    user.update(password: password)
  end

  private

  def user_valid?
    if user.blank?
      errors.add(:base, 'User not found')
    end
  end
end
