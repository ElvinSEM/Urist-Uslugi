class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json
  before_action :prevent_page_caching, only: :new
  before_action :inject_jwt_from_cookie, only: :destroy
  after_action :store_jwt_cookie, only: :create

  def new
    return redirect_to(after_sign_in_path_for(current_user)) if user_signed_in?

    super
  end

  def respond_to_on_destroy(*args)
    clear_jwt_cookie
    super()
  end

  private

  def prevent_page_caching
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end

  def inject_jwt_from_cookie
    token = cookies.encrypted[:user_jwt]
    return if token.blank?

    request.env["HTTP_AUTHORIZATION"] ||= "Bearer #{token}"
  end

  def store_jwt_cookie
    token = request.env["warden-jwt_auth.token"]
    return if token.blank?

    cookies.delete(:jwt_blocked, path: "/")
    cookies.encrypted[:user_jwt] = {
      value: token,
      path: "/",
      expires: 30.days.from_now,
      httponly: true,
      same_site: :lax
    }
  end

  def clear_jwt_cookie
    cookies.delete(:user_jwt, path: "/")
    cookies.delete(:jwt_blocked, path: "/")
  end
end
