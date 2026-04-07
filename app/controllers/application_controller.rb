class ApplicationController < ActionController::Base
  include Pagy::Method
  include Pundit::Authorization
  include BreadcrumbsOnRails::ActionController
  include PageContext

  allow_browser versions: :modern
  # before_action :authenticate_user!, if: :protected_area?
  before_action :set_meta_defaults
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :forbidden!

  helper_method :pagy

  private

  def protected_area?
    request.path.start_with?("/admin")
  end

  def set_meta_defaults
    set_meta_tags(
      site: "Услуги Юриста",
      title: "Юридические услуги",
      description: "Онлайн-платформа юридических услуг с заявками, поиском и уведомлениями",
      keywords: %w[Услуги Юриста адвокат договор регистрация ооо недвижимость претензия],
      reverse: true,
      og: {
        title: "Услуги Юриста",
        description: "Подбор юридических услуг, онлайн-заявки и сопровождение клиентов",
        type: "website",
        url: request.original_url
      }
    )
  end

  def forbidden!
    redirect_back fallback_location: root_path, alert: "Недостаточно прав"
  end

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.admin?

    location = stored_location_for(resource)
    location.present? && !location.start_with?("/admin") ? location : root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
