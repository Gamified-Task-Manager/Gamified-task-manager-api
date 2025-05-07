module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [:create]

      def create
        result = UserService.create_user(user_params)

        if result.success?
          render json: {
            data: {
              id: result.user.id.to_s,
              type: 'user',
              attributes: {
                email: result.user.email,
                username: result.user.username,
                created_at: result.user.created_at,
                updated_at: result.user.updated_at,
                token: result.token
              }
            }
          }, status: :created
        else
          render json: ErrorSerializer.serialize(result.errors, 422), status: :unprocessable_entity
        end
      end

      def show
        render json: UserSerializer.new(current_user).serializable_hash, status: :ok
      end

      def profile
        render json: UserSerializer.new(current_user).serializable_hash
      end      

      private

      def user_params
        params.require(:user).permit(:username, :email, :password)
      end      
    end
  end
end