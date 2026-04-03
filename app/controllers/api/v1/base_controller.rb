class Api::V1::BaseController < ActionController::API
  include Devise::Controllers::Helpers
  include Pagy::Method
  include Pundit::Authorization

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
