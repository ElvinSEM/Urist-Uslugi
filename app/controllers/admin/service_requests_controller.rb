class Admin::ServiceRequestsController < Admin::BaseController
  def index
    @service_requests = ServiceRequest.includes(:service, :client, :lawyer).recent
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
  end

  def transition
    service_request = ServiceRequest.find(params[:id])
    ServiceRequests::Transition.call(
      service_request: service_request,
      status: params[:status],
      actor: current_user,
      lawyer_id: params[:lawyer_id]
    )
    redirect_to admin_service_request_path(service_request), notice: "Статус обновлен"
  end
end
