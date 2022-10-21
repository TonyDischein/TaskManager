class User < ApplicationRecord
  include Recoverable
  has_secure_password validations: false

  has_many :my_tasks, class_name: 'Task', foreign_key: :author_id
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id

  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: /@/
  validates :password, confirmation: true, allow_blank: false
end
