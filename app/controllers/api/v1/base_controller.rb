class Api::V1::BaseController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  include Devise::Controllers::Helpers
  include Pagy::Method
  include Pundit::Authorization

  before_action :inject_jwt_from_cookie
  before_action :authenticate_user!, unless: :public_endpoint?

  rescue_from ActiveRecord::RecordNotFound do |error|
    render json: { error: error.message }, status: :not_found
  end

  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "forbidden" }, status: :forbidden
  end

  private

  def public_endpoint?
    false
  end

  def inject_jwt_from_cookie
    token = cookies.encrypted[:user_jwt]
    return if token.blank?

    request.env["HTTP_AUTHORIZATION"] ||= "Bearer #{token}"
  end

  def pagination_meta(pagy)
    {
      page: pagy.page,
      limit: pagy.limit,
      pages: pagy.pages,
      count: pagy.count,
      next: pagy.next,
      prev: pagy.prev
    }
  end
end
