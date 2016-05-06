class ApiBaseController < ActionController::Base
  respond_to :json

  before_action :authenticate_user!
  prepend_before_action :get_auth_token

  private

  def get_auth_token
    if auth_token = params[:token].blank? && request.headers["X-AUTH-TOKEN"]
      params[:token] = auth_token
    end
  end

  def authenticate_user!
    if params[:token]
      @current_user = User.find_by(api_token: params[:token])
      return render json: {
        error: {
          message: "Authentication Token invalid. You must provide a valid authentication token in your request.",
          type: 'Authentication Error.'
        }
      }, status: 401 unless @current_user
    else
      return render json: {
        error: {
          message: 'Authentication Token missing. You must provide an authentication token in your request.',
          type: 'Authentication Error.'
        }
      }, status: 401
    end
  end

  def current_user
    @current_user
  end
end
