class SendTaskDeleteNotificationJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer

  def perform(task)
    task = JSON.parse(task, object_class: OpenStruct)
    user = User.find_by(id: task.author_id)

    return if task.blank? || user.blank?

    UserMailer.with(user: user, task: task).task_deleted.deliver_now
  end
end
