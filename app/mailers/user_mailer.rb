class UserMailer < ApplicationMailer
  def task_created
    user = params[:user]
    @task = params[:task]

    mail(to: user.email, subject: 'New Task Created')
  end

  def task_updated
    @task = params[:task]
    user = params[:user]

    users = User.where(id: [@task.author_id, @task.assignee_id]).pluck(:email)
    users |= [user.email]

    mail(to: users, subject: "Task #{@task.id} Updated")
  end

  def task_deleted
    user = params[:user]
    @task = params[:task]

    mail(to: user.email, subject: "Task #{@task.id} Deleted")
  end
end
