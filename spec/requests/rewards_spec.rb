require 'rails_helper'

RSpec.describe "Api::V1::Rewards", type: :request do
  let(:user) { create(:user, theme: nil, avatar: nil) }
  let(:headers) { auth_headers(user) }
  let!(:rewards) { create_list(:reward, 3, active: true) }

  describe "GET /api/v1/rewards" do
    it "returns a list of active rewards" do
      get "/api/v1/rewards", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(3)
    end
  end

  describe "GET /api/v1/rewards/:id" do
    it "returns a single reward" do
      reward = rewards.first
      get "/api/v1/rewards/#{reward.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["attributes"]["name"]).to eq(reward.name)
    end

    it "returns 404 if reward is inactive" do
      reward = create(:reward, active: false)
      get "/api/v1/rewards/#{reward.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
