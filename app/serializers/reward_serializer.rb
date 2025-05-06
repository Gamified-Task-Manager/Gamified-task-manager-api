class RewardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :points_required, :image_url, :reward_type
end
