module Api
  module V1
    class AuthController < ApplicationController
      # Skip authentication for login and register routes
      skip_before_action :authenticate_request!, only: [:login, :register], raise: false

      # POST /api/v1/auth/register
      def register
        user = User.new(user_params.merge(role: "student"))
        if user.save
          token = JsonWebToken.encode(user_id: user.id, role: user.role)
          render json: { token: token, user: user_response(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        # Safely extract email & password regardless of frontend nesting
        email_param = params[:email].is_a?(String) ? params[:email] : params.dig(:auth, :email) || params.dig(:user, :email)
        password_param = params[:password].is_a?(String) ? params[:password] : params.dig(:auth, :password) || params.dig(:user, :password)

        user = User.find_by(email: email_param.to_s.downcase)

        if user&.authenticate(password_param)
          token = JsonWebToken.encode(user_id: user.id, role: user.role)
          render json: { token: token, user: user_response(user) }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def user_response(user)
        { id: user.id, name: user.name, email: user.email, role: user.role }
      end
    end
  end
end