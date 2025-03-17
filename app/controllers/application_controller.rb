class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from JWT::DecodeError, with: :render_unauthorized
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
  
    if token.present?
      decoded = AuthService.decode(token) rescue nil
      @current_user = User.find(decoded[:user_id]) if decoded
      raise ActiveRecord::RecordNotFound unless @current_user
    end
    
    render_unauthorized unless @current_user
  end
  

  def current_user
    @current_user
  end

  def render_unauthorized
    render json: ErrorMessageSerializer.serialize('Not authorized', 401), status: :unauthorized
  end

  def render_not_found
    render json: ErrorMessageSerializer.serialize('Not found', 404), status: :not_found
  end
end
