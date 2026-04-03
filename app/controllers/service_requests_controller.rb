class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!, except: %i[new create]

  def index
    add_breadcrumb "Мои заявки", service_requests_path
    @service_requests = policy_scope(ServiceRequest).includes(:service, :client, :lawyer).recent
    set_meta_tags(title: "Мои заявки", description: "Отслеживание статусов юридических заявок")
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
    authorize @service_request
    add_breadcrumb "Мои заявки", service_requests_path
    add_breadcrumb "Заявка ##{@service_request.id}", service_request_path(@service_request)
    set_meta_tags(title: "Заявка ##{@service_request.id}", description: "Детали и статус юридической заявки")
  end

  def new
    @service_request = ServiceRequest.new(service_id: params[:service_id])
    @service = Service.find_by(id: params[:service_id])
    add_breadcrumb "Услуги", services_path
    add_breadcrumb "Новая заявка", new_service_request_path(service_id: params[:service_id])
    set_meta_tags(title: "Новая заявка", description: "Форма отправки юридической заявки")
  end

  def create
    @service_request = ServiceRequests::Create.call(params: service_request_params, actor: current_user)
    redirect_to @service_request, notice: "Заявка отправлена"
  rescue ActiveRecord::RecordInvalid => e
    @service_request = e.record
    @service = Service.find_by(id: @service_request.service_id)
    render :new, status: :unprocessable_entity
  end

  private

  def service_request_params
    params.require(:service_request).permit(:service_id, :full_name, :email, :phone, :description)
  end
end
