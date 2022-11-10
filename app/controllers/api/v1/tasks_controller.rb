class Api::V1::TasksController < Api::V1::ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = Task.includes([:author, :assignee]).order(id: :desc).
      ransack(ransack_params).
      result.
      page(page).
      per(per_page)

    respond_with(tasks, each_serializer: TaskSerializer, root: 'items', meta: build_meta(tasks))
  end

  def show
    respond_with(@task, serializer: TaskSerializer)
  end

  def create
    task = current_user.my_tasks.new(task_params)

    SendTaskCreateNotificationJob.perform_async(task.id) if task.save

    respond_with(task, serializer: TaskSerializer)
  end

  def update
    SendTaskUpdateNotificationJob.perform_async(@task.id) if @task.update(task_params)

    respond_with(@task, serializer: TaskSerializer)
  end

  def destroy
    SendTaskDeleteNotificationJob.perform_async(@task.id, @task.author_id) if @task.destroy

    respond_with(@task)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :author_id, :assignee_id, :state_event, :expired_at)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
