class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!, except: %i[new create success]

  def index
    set_page_context(
      title: "Мои заявки",
      description: "Отслеживание статусов юридических заявок",
      breadcrumbs: [["Мои заявки", service_requests_path]],
      og: { url: service_requests_url }
    )
    @service_requests = policy_scope(ServiceRequest).includes(:service, :client, :lawyer).recent
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
    authorize @service_request
    set_page_context(
      title: "Заявка ##{@service_request.id}",
      description: "Детали и статус юридической заявки",
      breadcrumbs: [
        ["Мои заявки", service_requests_path],
        ["Заявка ##{@service_request.id}", service_request_path(@service_request)]
      ],
      og: { url: service_request_url(@service_request) }
    )
  end

  def new
    @service_request = ServiceRequest.new(service_id: params[:service_id])
    @service = Service.find_by(id: params[:service_id])
    set_page_context(
      title: "Новая заявка",
      description: "Форма отправки юридической заявки",
      breadcrumbs: [
        ["Услуги", services_path],
        ["Новая заявка", new_service_request_path(service_id: params[:service_id])]
      ],
      og: { url: new_service_request_url(service_id: params[:service_id]) }
    )
  end

  def create
    @service_request = ServiceRequests::Create.call(params: service_request_params, actor: current_user)
    respond_to do |format|
      format.html do
        if current_user.present?
          redirect_to @service_request, notice: "Заявка отправлена"
        else
          redirect_to success_service_requests_path, notice: "Заявка отправлена"
        end
      end
      format.turbo_stream do
        flash.now[:notice] = "Заявка отправлена"
        render turbo_stream: [
          turbo_stream.update("lead_form", partial: "shared/lead_form_success", locals: { service_request: @service_request }),
          turbo_stream.replace("flash", partial: "shared/flash")
        ]
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @service_request = e.record
    @service = Service.find_by(id: @service_request.service_id)
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "lead_form",
          partial: "shared/lead_form_form",
          locals: { service_request: @service_request, services: Service.published.ordered.includes(:category) }
        ), status: :unprocessable_entity
      end
    end
  end

  def success
    set_page_context(
      title: "Заявка отправлена",
      description: "Спасибо. Мы получили вашу заявку и уже начали обработку.",
      breadcrumbs: [
        ["Услуги", services_path],
        ["Заявка отправлена", success_service_requests_path]
      ],
      og: { url: success_service_requests_url }
    )
  end

  private

  def service_request_params
    params.require(:service_request).permit(:service_id, :full_name, :email, :phone, :description)
  end
end
