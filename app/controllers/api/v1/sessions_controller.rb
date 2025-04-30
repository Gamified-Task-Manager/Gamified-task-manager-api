module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: [:create]

      def create
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          token = AuthService.encode(user_id: user.id)

          user_data = UserSerializer.new(user).serializable_hash[:data]
          user_data[:attributes][:token] = token  # Clearly add token here
          user_data[:attributes][:points] = user.points

          render json: { data: user_data }, status: :created
        else
          render json: ErrorMessageSerializer.serialize('Invalid email or password', 401), status: :unauthorized
        end
      end
    end
  end
end
