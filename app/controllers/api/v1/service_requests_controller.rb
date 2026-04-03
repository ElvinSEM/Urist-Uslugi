class Api::V1::ServiceRequestsController < Api::V1::BaseController
  before_action :set_service_request, only: %i[show update transition]

  def index
    scope = policy_scope(ServiceRequest).includes(:service, :client, :lawyer).recent
    scope = scope.with_status(params[:status])
    @pagy, records = pagy(scope)
    render json: { data: records.map { |record| Api::V1::ServiceRequestSerializer.call(record) }, meta: pagination_meta(@pagy) }
  end

  def show
    authorize @service_request
    render json: { data: Api::V1::ServiceRequestSerializer.call(@service_request) }
  end

  def create
    record = ServiceRequests::Create.call(params: service_request_params, actor: current_user)
    render json: { data: Api::V1::ServiceRequestSerializer.call(record) }, status: :created
  end

  def update
    authorize @service_request
    @service_request.update!(service_request_params.except(:service_id))
    render json: { data: Api::V1::ServiceRequestSerializer.call(@service_request) }
  end

  def transition
    authorize @service_request, :transition?
    ServiceRequests::Transition.call(
      service_request: @service_request,
      status: params[:status],
      actor: current_user,
      lawyer_id: params[:lawyer_id]
    )
    render json: { data: Api::V1::ServiceRequestSerializer.call(@service_request.reload) }
  end

  private

  def set_service_request
    @service_request = ServiceRequest.find(params[:id])
  end

  def service_request_params
    params.require(:service_request).permit(:service_id, :full_name, :email, :phone, :description)
  end
end
