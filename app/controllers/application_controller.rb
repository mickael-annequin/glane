class ApplicationController < ActionController::Base
  # Glane is private: every page needs a signed-in person (except Devise's sign-in page).
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  # After signing out (or with a wrong invitation link), go straight to the sign-in page:
  # going through the home page would replace Devise's message with "Connectez-vous pour continuer".
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  # When accepting an invitation, the person also gives their name and phone.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[name phone])
  end
end
