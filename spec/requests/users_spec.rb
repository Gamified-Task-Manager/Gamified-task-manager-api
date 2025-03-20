require 'rails_helper'

RSpec.describe 'User Requests', type: :request do
  let!(:user) do
    User.create(
      email: 'test@example.com',
      username: 'TestUser',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  def auth_headers(user)
    token = AuthService.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'POST /api/v1/users' do
    context 'with valid data' do
      let(:valid_params) do
        {
          username: 'newuser',
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      before do
        allow(UserService).to receive(:create_user).and_return(
          OpenStruct.new(success?: true, user: User.new(valid_params), token: 'fake-jwt-token')
        )
        post '/api/v1/users', params: valid_params
      end

      it 'creates a new user and returns a token' do
        expect(response).to have_http_status(:created)

        body = JSON.parse(response.body)
        expect(body['data']['attributes']['email']).to eq('new@example.com')
        expect(body['data']['attributes']['token']).to eq('fake-jwt-token')
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {
          username: '',
          email: '',
          password: 'password123',
          password_confirmation: 'wrongpassword'
        }
      end

      before do
        allow(UserService).to receive(:create_user).and_return(
          OpenStruct.new(success?: false, user: nil, token: nil, errors: [
            "Email can't be blank",
            "Username can't be blank",
            "Password confirmation doesn't match Password"
          ])
        )
        post '/api/v1/users', params: invalid_params
      end

      it 'returns an error' do
        expect(response).to have_http_status(:unprocessable_entity)

        body = JSON.parse(response.body)
        error_titles = body['errors'].map { |e| e['title'] }

        expect(error_titles).to include("Email can't be blank")
        expect(error_titles).to include("Username can't be blank")
        expect(error_titles).to include("Password confirmation doesn't match Password")
      end
    end
  end

  context 'when user does not exist' do
    let(:deleted_user) { create(:user) }
    let(:deleted_token) { AuthService.encode(user_id: deleted_user.id) }
  
    before do
      deleted_user.destroy
      get '/api/v1/users/profile', headers: { 'Authorization' => "Bearer #{deleted_token}" }
    end
  
    it 'returns user not found error' do
      expect(response).to have_http_status(:not_found)
  
      body = JSON.parse(response.body)
      expect(body['errors'][0]['title']).to eq('Not found') 
    end
  end  

  describe 'GET /api/v1/users/profile' do
    context 'when authorized' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        get '/api/v1/users/profile', headers: auth_headers(user)
      end

      it 'returns the user profile' do
        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body['data']['attributes']['email']).to eq(user.email)
      end
    end

    context 'when unauthorized' do
      before { get '/api/v1/users/profile' }

      it 'returns unauthorized error' do
      expect(response).to have_http_status(:unauthorized)

      body = JSON.parse(response.body)
      puts response.body
      expect(body['errors'][0]['title']).to eq('Not authorized')
      end
    end
  end
end
