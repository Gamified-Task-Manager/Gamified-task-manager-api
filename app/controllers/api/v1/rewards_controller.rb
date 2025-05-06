class Api::V1::RewardsController < ApplicationController
  before_action :authorize_request
  before_action :set_reward, only: [:show]

  def index
    rewards = Reward.where(active: true)
    render json: RewardSerializer.new(rewards).serializable_hash, status: :ok
  end

  def show
    if @reward
      render json: RewardSerializer.new(@reward).serializable_hash, status: :ok
    else
      render json: ErrorMessageSerializer.serialize('Reward not found', 404), status: :not_found
    end
  end

  private

  def set_reward
    @reward = Reward.find_by(id: params[:id], active: true)
  end
end

