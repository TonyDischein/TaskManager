class Task < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true

  validates :name, :description, :author, presence: true
  validates :description, length: { maximum: 500 }

  def self.predevelop_states
    [:new_task, :in_qa, :in_code_review]
  end

  state_machine initial: :new_task do
    event :begin_develop do
      transition Task.predevelop_states => :in_development
    end

    event :archive do
      transition new_task: :archived
      transition released: :archived
    end

    event :begin_test do
      transition in_development: :in_qa
    end

    event :begin_code_review do
      transition in_qa: :in_code_review
    end

    event :ready_for_release do
      transition in_code_review: :ready_for_release
    end

    event :release do
      transition ready_for_release: :released
    end
  end
end
