class TaskService
  def initialize(user)
    @user = user
  end

  def create(params)
    task = @user.tasks.new(params)
    if task.save
      task
    else
      raise ServiceError.new(task.errors.full_messages, 422)
    end
  end

  def update(task, params)
    if task.completed? && (params[:status] != "completed" || params[:completed] == false)
      raise ServiceError.new(["You cannot modify a completed task."], 422)
    end

    was_previously_completed = task.completed?

    if task.update(params)
      award_points_if_applicable(task, was_previously_completed)
      task
    else
      raise ServiceError.new(task.errors.full_messages, 422)
    end
  end

  def destroy(task)
    task.destroy!
  rescue ActiveRecord::RecordNotDestroyed
    raise ServiceError.new("Failed to destroy task", 422)
  end

  private

  def award_points_if_applicable(task, was_previously_completed)
    return unless !was_previously_completed && task.status == "completed"
  
    points = task.calculate_points
    task.update!(points_awarded: points)
    @user.award_points!(points)
  end
end
