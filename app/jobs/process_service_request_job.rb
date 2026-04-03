class ProcessServiceRequestJob < ApplicationJob
  queue_as :default

  def perform(service_request_id)
    service_request = ServiceRequest.includes(:client, :service).find(service_request_id)
    Notifications::Dispatch.call(
      user: service_request.client,
      title: "Новая заявка принята",
      body: "Мы получили вашу заявку на услугу #{service_request.service.title}",
      notifiable: service_request
    )
  end
end
