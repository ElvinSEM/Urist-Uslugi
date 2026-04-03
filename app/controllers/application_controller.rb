class ApplicationController < ActionController::Base
  include Pagy::Method
  include Pundit::Authorization
  include BreadcrumbsOnRails::ActionController

  allow_browser versions: :modern
  before_action :authenticate_user!, if: :protected_area?
  before_action :set_meta_defaults

  rescue_from Pundit::NotAuthorizedError, with: :forbidden!

  helper_method :pagy

  private

  def protected_area?
    request.path.start_with?("/admin")
  end

  def set_meta_defaults
    set_meta_tags(
      site: "Юрист Услуги",
      title: "Юридические услуги",
      description: "Онлайн-платформа юридических услуг с заявками, поиском и уведомлениями",
      keywords: %w[юрист адвокат договор регистрация ооо недвижимость претензия],
      reverse: true,
      og: {
        title: "Юрист Услуги",
        description: "Подбор юридических услуг, онлайн-заявки и сопровождение клиентов",
        type: "website",
        url: request.original_url
      }
    )
  end

  def forbidden!
    redirect_back fallback_location: root_path, alert: "Недостаточно прав"
  end
end
