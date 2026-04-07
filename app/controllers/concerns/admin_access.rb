module AdminAccess
  extend ActiveSupport::Concern

  included do
    before_action :ensure_admin!
  end

  private

  def ensure_admin!
    raise Pundit::NotAuthorizedError unless current_user&.admin?
  end
end
