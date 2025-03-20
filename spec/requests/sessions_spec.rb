require 'rails_helper'

RSpec.describe 'User Sessions', type: :request do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

  describe 'POST /api/v1/session' do
    context 'with valid credentials' do
      it 'returns a token and user data' do
        post '/api/v1/session', params: { email: user.email, password: 'password123' }

        expect(response).to have_http_status(:created)

        body = JSON.parse(response.body)
        attributes = body['data']['attributes']

        expect(attributes['email']).to eq(user.email)
        expect(attributes['token']).to be_present 
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post '/api/v1/session', params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)

        body = JSON.parse(response.body)
        expect(body['errors'][0]['title']).to eq('Invalid email or password')
      end
    end
  end
end
