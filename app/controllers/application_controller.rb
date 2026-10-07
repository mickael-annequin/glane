class ApplicationController < ActionController::Base
  # Access rights: who can do what is written in app/policies (one file per model).
  include Pundit::Authorization

  # Glane is private: every page needs a signed-in person (except Devise's sign-in page).
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Every page must check the access rights: if one forgets, Rails raises an error instead of showing it.
  # (The pages that only show the signed-in person's own things skip this check.)
  after_action :verify_authorized, unless: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  # Something not allowed: back to the home page, with the reason written in config/locales/pundit.fr.yml.
  def not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    redirect_to root_path, alert: t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
  end

  # After signing out (or with a wrong invitation link), go straight to the sign-in page:
  # going through the home page would replace Devise's message with "Connectez-vous pour continuer".
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  # Adds the planning sent by app/views/shared/_schedule_fields.html.erb (when the form has one) to the permitted params.
  def with_schedule(permitted, attribute, form_params)
    return permitted unless form_params&.key?(attribute)

    permitted.merge(attribute => Schedule.from_form(form_params[attribute]).to_h)
  end

  # When accepting an invitation, the person also gives their name and phone.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[name phone])
  end
end
