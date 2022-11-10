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

  def attach_image
    task = Task.find(params[:id])

    task_attach_image_form = TaskAttachImageForm.new(attachment_params)

    if task_attach_image_form.invalid?
      respond_with(task_attach_image_form)
      return
    end

    image = task_attach_image_form.processed_image

    task.image.attach(image)

    respond_with(task, serializer: TaskSerializer)
  end

  def remove_image
    task = Task.find(params[:id])
    task.image.purge

    respond_with(task, serializer: TaskSerializer)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :author_id, :assignee_id, :state_event, :expired_at)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:image, :crop_x, :crop_y, :crop_width, :crop_height)
  end
end
