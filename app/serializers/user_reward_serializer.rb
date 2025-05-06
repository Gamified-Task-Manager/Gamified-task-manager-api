class UserRewardSerializer
  include JSONAPI::Serializer
  attributes :id, :reward_id, :purchased, :unlocked
end
