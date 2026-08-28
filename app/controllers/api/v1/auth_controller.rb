module Api
  module V1
    class AuthController < ApplicationController
      # POST /api/v1/auth/register
      def register
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id, role: user.role)
          render json: { token: token, user: user_response(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id, role: user.role)
          render json: { token: token, user: user_response(user) }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
      end

      def user_response(user)
        { id: user.id, name: user.name, email: user.email, role: user.role }
      end
    end
  end
end
