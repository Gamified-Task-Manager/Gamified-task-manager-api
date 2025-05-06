class RewardService
  def initialize(user)
    @user = user
  end

  def purchase(reward)
    raise ServiceError.new(["Insufficient points"], 422) if @user.points < reward.points_required

    user_reward = @user.user_rewards.find_or_initialize_by(reward: reward)

    if user_reward.purchased
      raise ServiceError.new(["Reward already purchased"], 422)
    end

    ActiveRecord::Base.transaction do
      @user.update!(points: @user.points - reward.points_required)
      user_reward.update!(purchased: true, unlocked: true)
    end

    user_reward
  end
end
