class Admin::ServiceRequestsController < Admin::BaseController
  before_action :set_service_request, only: %i[show transition edit update destroy]

  def index
    @service_requests = ServiceRequest.includes(:service, :client, :lawyer).recent
  end

  def show
  end

  def transition
    ServiceRequests::Transition.call(
      service_request: @service_request,
      status: params[:status],
      actor: current_user,
      lawyer_id: params[:lawyer_id]
    )
    redirect_to admin_service_request_path(@service_request), notice: "Статус обновлен"
  rescue ArgumentError, ActiveRecord::RecordInvalid => e
    redirect_to admin_service_request_path(@service_request), alert: e.message
  end

  def new
    redirect_to admin_service_requests_path, alert: "Создание заявки доступно через публичную форму"
  end

  def create
    redirect_to admin_service_requests_path, alert: "Создание заявки доступно через публичную форму"
  end

  def edit
    redirect_to admin_service_request_path(@service_request), alert: "Редактирование заявки недоступно"
  end

  def update
    redirect_to admin_service_request_path(@service_request), alert: "Редактирование заявки недоступно"
  end

  def destroy
    redirect_to admin_service_requests_path, alert: "Удаление заявки недоступно"
  end

  private

  def set_service_request
    @service_request = ServiceRequest.includes(:service, :client, :lawyer, :audits).find(params[:id])
  end
end
