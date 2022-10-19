class UserMailerPreview < ActionMailer::Preview
  def task_created
    params = get_message_data

    UserMailer.with(params).task_created
  end

  def task_updated
    params = get_message_data

    UserMailer.with(params).task_updated
  end

  def task_deleted
    params = get_message_data

    UserMailer.with(params).task_deleted
  end

  private

  def get_message_data
    user = User.first
    task = Task.first
    { user: user, task: task }
  end
end
