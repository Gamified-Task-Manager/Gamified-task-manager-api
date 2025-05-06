require 'rails_helper'

RSpec.describe RewardService, type: :service do
  let(:user) { create(:user, points: 100) }
  let(:reward) { create(:reward, points_required: 50) }

  subject { described_class.new(user) }

  describe "#purchase" do
    context "with enough points" do
      it "deducts points and marks reward as purchased" do
        result = subject.purchase(reward)

        expect(result).to be_purchased
        expect(result.reward_id).to eq(reward.id)
        expect(user.reload.points).to eq(50)
      end
    end

    context "with insufficient points" do
      before { user.update(points: 10) }

      it "raises ServiceError with appropriate message" do
        expect {
          subject.purchase(reward)
        }.to raise_error(ServiceError) do |error|
          expect(error.errors).to include("Insufficient points")
        end
      end
    end

    context "when reward already purchased" do
      before do
        user.user_rewards.create!(reward: reward, purchased: true)
      end

      it "raises ServiceError with appropriate message" do
        expect {
          subject.purchase(reward)
        }.to raise_error(ServiceError) do |error|
          expect(error.errors).to include("Reward already purchased")
        end
      end
    end
  end
end
