Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = ["ActionController::API", "ApplicationController"]
  config.lograge.custom_payload do |controller|
    { request_id: controller.request.request_id, user_id: controller.try(:current_user)&.id }
  end
end
