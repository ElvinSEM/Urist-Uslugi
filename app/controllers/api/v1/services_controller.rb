class Api::V1::ServicesController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_service, only: %i[show update destroy]

  def index
    filter = Search::ServicesFilter.new(params.permit(:query, :category_id, :price_from, :price_to))
    scope = filter.apply(policy_scope(Service).includes(:category).ordered)
    @pagy, services = pagy(scope)
    render json: { data: services.map { |service| Api::V1::ServiceSerializer.call(service) }, meta: pagination_meta(@pagy) }
  end

  def show
    authorize @service
    render json: { data: Api::V1::ServiceSerializer.call(@service) }
  end

  def create
    service = Service.new(service_params)
    authorize service
    service.save!
    render json: { data: Api::V1::ServiceSerializer.call(service) }, status: :created
  end

  def update
    authorize @service
    @service.update!(service_params)
    render json: { data: Api::V1::ServiceSerializer.call(@service) }
  end

  def destroy
    authorize @service
    @service.destroy!
    head :no_content
  end

  private

  def set_service
    @service = Service.friendly.find(params[:slug])
  end

  def service_params
    params.require(:service).permit(:category_id, :title, :description, :price_cents, :published, :position)
  end
end
