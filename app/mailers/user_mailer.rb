class UserMailer < ApplicationMailer
  def task_created
    user, @task = get_message_data

    mail(to: user.email, subject: 'New Task Created')
  end

  def task_updated
    user, @task = get_message_data
    users = get_recipients_list(user)

    mail(to: users, subject: "Task #{@task.id} Updated")
  end

  def task_deleted
    user, @task = get_message_data

    mail(to: user.email, subject: "Task #{@task.id} Deleted")
  end

  private

  def get_message_data
    [params[:user], params[:task]]
  end

  def get_recipients_list(user)
    users = User.where(id: [@task.author_id, @task.assignee_id]).pluck(:email)
    users | [user.email]
  end
end
