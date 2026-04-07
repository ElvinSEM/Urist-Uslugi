class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  before_action :prevent_page_caching, only: %i[new edit]

  private

  def prevent_page_caching
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end
end
