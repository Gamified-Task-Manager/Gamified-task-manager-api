class UserRewardService
  def initialize(user)
    @user = user
  end

  def apply(user_reward)
    unless user_reward.purchased
      raise ServiceError.new(["Reward must be purchased before applying"], 422)
    end

    reward = user_reward.reward

    case reward.reward_type
    when 'theme'
      @user.update!(theme_id: reward.id)
    when 'avatar'
      @user.update!(avatar_id: reward.id)
    else
      raise ServiceError.new(["This type of reward cannot be applied"], 422)
    end
  end
end
