class TaskQuery
  # Returns all tasks for a user, with optional filters and sorting
  def self.for_user(user, params = {})
    # Start with just this user's tasks
    tasks = Task.where(user: user)

    # Optional filters
    # If a status (like "completed") is provided, filter by it
    tasks = tasks.where(status: params[:status]) if params[:status].present?

    # If a priority is provided (like "high"), filter by it
    tasks = tasks.where(priority: params[:priority]) if params[:priority].present?

    # If completed=true or false is passed, filter by it
    if params.key?(:completed)
      tasks = tasks.where(completed: ActiveModel::Type::Boolean.new.cast(params[:completed]))
    end

    # If due_before is passed (e.g., "2025-05-01"), show tasks due before that date
    if params[:due_before].present?
      tasks = tasks.where("due_date <= ?", params[:due_before])
    end

    # Sorting — based on the value of sort_by
    case params[:sort_by]
    when "due_date"
      # Sort soonest to latest
      tasks = tasks.order(due_date: :asc)

    when "priority"
      # Custom sort: high → medium → low using a SQL trick
      tasks = tasks.order(
        Arel.sql("CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END ASC")
      )

    when "name"
      # Sort alphabetically by task name
      tasks = tasks.order("LOWER(name) ASC")

    else
      # Default sort (most recently created first)
      tasks = tasks.order(created_at: :desc)
    end

    # Return the final filtered and sorted list
    tasks
  end

  # --- Existing simpler methods below ---

  # Get only incomplete tasks for a user
  def self.incomplete_for_user(user)
    Task.where(user: user, completed: false)
  end

  # Get only high-priority tasks for a user
  def self.high_priority_for_user(user)
    Task.where(user: user, priority: 'high')
  end

  # Get tasks with a specific status (e.g., "in_progress")
  def self.by_status_for_user(user, status)
    Task.where(user: user, status: status)
  end

  # Find one specific task by ID for this user
  def self.find_for_user(user, id)
    user.tasks.find_by(id: id)
  end
end
