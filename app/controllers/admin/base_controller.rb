class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  layout "admin"

  private

  def ensure_admin!
    raise Pundit::NotAuthorizedError unless current_user&.admin?
  end
end
