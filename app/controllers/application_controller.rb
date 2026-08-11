class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_current_user

  helper_method :current_user, :signed_in?

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

  def current_user
    Current.user
  end

  def signed_in?
    current_user.present?
  end

  def require_authentication
    return if signed_in?

    session[:return_to] = request.fullpath if request.get?
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Please sign in to continue." }
      format.json { render json: { error: "Authentication required" }, status: :unauthorized }
    end
  end

  def render_forbidden
    respond_to do |format|
      format.html { redirect_to root_path, alert: "You are not allowed to do that." }
      format.json { render json: { error: "Forbidden" }, status: :forbidden }
    end
  end
end
