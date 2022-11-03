class UserMailer < ApplicationMailer
  before_action do
    @user = params[:user]
    @task = params[:task]
  end
  before_action :set_recipients_list, only: [:task_updated]

  def task_created
    mail(to: @user.email, subject: 'New Task Created')
  end

  def task_updated
    mail(to: @users, subject: "Task #{@task.id} Updated")
  end

  def task_deleted
    @task_id = @task

    mail(to: @user.email, subject: "Task #{@task_id} Deleted")
  end

  private

  def set_recipients_list
    @users = User.where(id: [@task.author_id, @task.assignee_id]).pluck(:email)
    @users | [@user.email]
  end
end
