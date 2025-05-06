require 'rails_helper'

RSpec.describe UserRewardService, type: :service do
  let(:user) { create(:user) }

  describe "#apply" do
    context "when reward is purchased and a theme" do
      let(:reward) { create(:reward, reward_type: 'theme') }
      let!(:theme) { create(:theme, id: reward.id) }
      let(:user_reward) { create(:user_reward, user: user, reward: reward, purchased: true) }

      it "applies the theme to the user" do
        described_class.new(user).apply(user_reward)
        expect(user.reload.theme_id).to eq(reward.id)
      end
    end

    context "when reward is not purchased" do
      let(:reward) { create(:reward, reward_type: 'theme') }
      let!(:theme) { create(:theme, id: reward.id) }
      let(:user_reward) { create(:user_reward, user: user, reward: reward, purchased: false) }

      it "raises ServiceError with appropriate message" do
        expect {
          described_class.new(user).apply(user_reward)
        }.to raise_error(ServiceError) do |error|
          expect(error.errors).to include("Reward must be purchased before applying")
        end
      end
    end

    context "with unsupported reward type" do
      let(:reward) { create(:reward, reward_type: 'game') }
      let(:user_reward) { create(:user_reward, user: user, reward: reward, purchased: true) }

      it "raises ServiceError with appropriate message" do
        expect {
          described_class.new(user).apply(user_reward)
        }.to raise_error(ServiceError) do |error|
          expect(error.errors).to include("This type of reward cannot be applied")
        end
      end
    end
  end
end
