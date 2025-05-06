class UserSerializer
  include JSONAPI::Serializer

  attributes :email, :username, :points, :theme_id, :avatar_id

  attribute :created_at do |user|
    user.created_at&.iso8601
  end

  attribute :updated_at do |user|
    user.updated_at&.iso8601
  end
end
