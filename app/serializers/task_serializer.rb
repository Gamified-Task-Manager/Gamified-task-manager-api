class TaskSerializer
  include JSONAPI::Serializer

  attributes :id,
             :name,
             :description,
             :completed,
             :status,
             :priority,
             :points_awarded,
             :due_date,
             :notes,
             :attachment_url,
             :created_at,
             :updated_at

  belongs_to :user, serializer: UserSerializer
end
