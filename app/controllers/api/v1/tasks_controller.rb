class Api::V1::TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = TaskQuery.for_user(@current_user, params)
    render json: TaskSerializer.new(tasks).serializable_hash, status: :ok
  end

  def show
    render json: TaskSerializer.new(@task).serializable_hash, status: :ok
  end

  def create
    task = TaskService.new(@current_user).create(task_params)
    render json: TaskSerializer.new(task).serializable_hash, status: :created
  rescue ServiceError => e
    render json: ErrorSerializer.serialize(e.errors, e.status), status: e.status
  end

  def update
    if @task.completed? && (task_params[:status] != "completed" || task_params[:completed] == false)
      render json: ErrorSerializer.serialize(["You cannot modify a completed task."], 422), status: :unprocessable_entity
      return
    end
    task = TaskService.new(@current_user).update(@task, task_params)
    render json: TaskSerializer.new(task).serializable_hash, status: :ok
  rescue ServiceError => e
    render json: ErrorSerializer.serialize(e.errors, e.status), status: e.status
  end

  def destroy
    TaskService.new(@current_user).destroy(@task)
    head :no_content
  rescue ServiceError => e
    render json: ErrorSerializer.serialize(e.errors, e.status), status: e.status
  end
  

  private

  def task_params
    params.require(:task).permit(
      :name,
      :description,
      :completed,
      :completed_at,
      :due_date,
      :priority,
      :category,
      :recurring,
      :recurrence_frequency,
      :notes,
      :attachment_url,
      :status,
      :points_awarded
    )
  end

  def set_task
    @task = TaskQuery.find_for_user(@current_user, params[:id])
    render_not_found unless @task
  end

  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = AuthService.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
      render_unauthorized unless @current_user
    else
      render_unauthorized
    end
  end

  def render_unauthorized
    render json: ErrorMessageSerializer.serialize('Not Authorized', 401), status: :unauthorized
  end

  def render_not_found
    render json: ErrorMessageSerializer.serialize('Task not found', 404), status: :not_found
  end
end
