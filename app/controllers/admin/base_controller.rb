class Admin::BaseController < ApplicationController

  layout "admin"

  private

  def ensure_admin!
    raise Pundit::NotAuthorizedError unless current_user&.admin?
  end
end
