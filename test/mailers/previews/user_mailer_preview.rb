class UserMailerPreview < ActionMailer::Preview
  def task_created
    UserMailer.with(get_message_data).task_created
  end

  def task_updated
    UserMailer.with(get_message_data).task_updated
  end

  def task_deleted
    UserMailer.with(get_message_data).task_deleted
  end

  private

  def get_message_data
    { user: User.first, task: Task.first }
  end
end
