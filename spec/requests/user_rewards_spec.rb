require 'rails_helper'

RSpec.describe "Api::V1::UserRewards", type: :request do
  let(:user) { create(:user, theme: nil, avatar: nil, points: 100) }
  let(:headers) { auth_headers(user).merge("Content-Type" => "application/json") }
  let!(:reward) { create(:reward, points_required: 50) }

  describe "GET /api/v1/user_rewards" do
    before do
      create(:user_reward, user: user, reward: reward, purchased: true)
    end

    it "returns user's rewards" do
      get "/api/v1/user_rewards", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(1)
      expect(json["data"].first["attributes"]["purchased"]).to eq(true)
    end
  end

  describe "POST /api/v1/user_rewards" do
    it "purchases a reward if user has enough points" do
      post "/api/v1/user_rewards",
        params: { user_reward: { reward_id: reward.id } }.to_json,
        headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["data"]["attributes"]["purchased"]).to eq(true)
    end

    it "fails if user has insufficient points" do
      user.update(points: 10)

      post "/api/v1/user_rewards",
        params: { user_reward: { reward_id: reward.id } }.to_json,
        headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"].first["title"]).to include("Insufficient points")
    end
  end

  describe "PATCH /api/v1/user_rewards/:id" do
    context "when applying a theme" do
      let(:reward) { create(:reward, reward_type: 'theme') }
      let!(:theme) { create(:theme, id: reward.id) }
      let!(:user_reward) { create(:user_reward, user: user, reward: reward, purchased: true) }

      it "applies the theme to the user" do
        patch "/api/v1/user_rewards/#{user_reward.id}",
          params: { apply: true }.to_json,
          headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["meta"]["new_theme_id"]).to eq(reward.id)
      end
    end

    it "returns 404 if user_reward not found" do
      patch "/api/v1/user_rewards/999999",
        params: { apply: true }.to_json,
        headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/user_rewards" do
    it "returns 404 if the reward is not found or inactive" do
      post "/api/v1/user_rewards",
        params: { user_reward: { reward_id: -1 } }.to_json,
        headers: headers
  
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["errors"].first["title"]).to eq("Reward not found")
    end
  end
  
  describe "PATCH /api/v1/user_rewards/:id" do
    context "when applying an unpurchased reward" do
      let(:reward) { create(:reward, reward_type: 'theme') }
      let!(:theme) { create(:theme, id: reward.id) }
      let!(:user_reward) { create(:user_reward, user: user, reward: reward, purchased: false) }
  
      it "rescues and returns a ServiceError" do
        patch "/api/v1/user_rewards/#{user_reward.id}",
          params: { apply: true }.to_json,
          headers: headers
  
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"].first["title"]).to include("must be purchased")
      end
    end
  end

  describe "PATCH /api/v1/user_rewards/:id without apply flag" do
    let(:user_reward) { create(:user_reward, user: user, unlocked: false) }
  
    it "updates user_reward successfully" do
      patch "/api/v1/user_rewards/#{user_reward.id}",
        params: { user_reward: { unlocked: true } }.to_json,
        headers: headers
  
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["attributes"]["unlocked"]).to eq(true)
    end
  end
  
  describe "PATCH /api/v1/user_rewards/:id without apply flag" do
    let(:user_reward) { create(:user_reward, user: user, unlocked: false) }
  
    it "returns 422 if update fails due to invalid data" do
      patch "/api/v1/user_rewards/#{user_reward.id}",
        params: { user_reward: { unlocked: nil } }.to_json, # nil fails validation
        headers: headers
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to be_an(Array)
      expect(json["errors"].first["title"]).to include("Unlocked is not included in the list")
    end
  end
end
