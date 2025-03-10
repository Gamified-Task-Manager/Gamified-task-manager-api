module Api
  module V1
    class UsersController < ApplicationController
      def show
        render json: @current_user, status: :ok
      end
    end
  end
end
