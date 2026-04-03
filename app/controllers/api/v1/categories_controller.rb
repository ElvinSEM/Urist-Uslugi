class Api::V1::CategoriesController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    categories = Category.order(:name)
    render json: { data: categories.map { |category| Api::V1::CategorySerializer.call(category) } }
  end

  def show
    category = Category.friendly.find(params[:slug])
    render json: { data: Api::V1::CategorySerializer.call(category) }
  end
end
