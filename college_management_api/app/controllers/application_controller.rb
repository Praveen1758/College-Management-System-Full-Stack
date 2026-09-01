class ApplicationController < ActionController::API
  # Register the callback so child controllers can inherit or skip it
  before_action :authenticate_request!

  attr_reader :current_user

  def authenticate_request!
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?
    
    # Use .with_indifferent_access so both string & symbol keys work (e.g. decoded[:user_id])
    decoded = JsonWebToken.decode(token)&.with_indifferent_access

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    end

    render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
  end

  def authorize_roles!(*roles)
    unless roles.map(&:to_s).include?(current_user&.role)
      render json: { error: "Forbidden: You do not have permission to perform this action" }, status: :forbidden
    end
  end
end