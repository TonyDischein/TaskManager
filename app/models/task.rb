class Task < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true

  validates :name, :description, :author, presence: true
  validates :description, length: { maximum: 500 }

  state_machine initial: :new_task do
    event :in_development do
      transition new_task: :in_development, in_qa: :in_development, in_code_review: :in_development
    end

    event :archived do
      transition new_task: :archived, released: :archived
    end

    event :in_qa do
      transition in_development: :in_qa
    end

    event :in_code_review do
      transition in_qa: :in_code_review
    end

    event :ready_for_release do
      transition in_code_review: :ready_for_release
    end

    event :released do
      transition ready_for_release: :released
    end
  end
end
