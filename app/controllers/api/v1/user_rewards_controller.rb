class Api::V1::UserRewardsController < ApplicationController
  before_action :authorize_request
  before_action :set_user_reward, only: [:update]

  def index
    user_rewards = @current_user.user_rewards.includes(:reward)
    render json: UserRewardSerializer.new(user_rewards).serializable_hash, status: :ok
  end

  def create
    reward = Reward.find_by(id: user_reward_params[:reward_id], active: true)
    unless reward
      return render json: ErrorMessageSerializer.serialize('Reward not found', 404), status: :not_found
    end

    user_reward = RewardService.new(@current_user).purchase(reward)
    render json: UserRewardSerializer.new(user_reward).serializable_hash.merge(
      meta: { new_user_points: @current_user.points }
    ), status: :created
  rescue ServiceError => e
    render json: ErrorSerializer.serialize(e.errors, e.status), status: e.status
  end

  def update
    if apply_param
      begin
        UserRewardService.new(@current_user).apply(@user_reward)
        render json: UserRewardSerializer.new(@user_reward).serializable_hash.merge(
          meta: {
            new_theme_id: @current_user.theme_id,
            new_avatar_id: @current_user.avatar_id
          }
        ), status: :ok
      rescue ServiceError => e
        render json: ErrorSerializer.serialize(e.errors, e.status), status: e.status
      end
    elsif @user_reward.update(user_reward_params)
      render json: UserRewardSerializer.new(@user_reward).serializable_hash, status: :ok
    else
      render json: ErrorSerializer.serialize(@user_reward.errors.full_messages, 422), status: :unprocessable_entity
    end
  end

  private

  def set_user_reward
    @user_reward = @current_user.user_rewards.find_by(id: params[:id])
    unless @user_reward
      render json: ErrorMessageSerializer.serialize('UserReward not found', 404), status: :not_found
    end
  end

  def user_reward_params
    params.require(:user_reward).permit(:reward_id, :purchased, :unlocked)
  end

  def apply_param
    ActiveModel::Type::Boolean.new.cast(params[:apply])
  end
end
