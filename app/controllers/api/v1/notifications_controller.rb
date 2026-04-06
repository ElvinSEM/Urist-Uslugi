class Api::V1::NotificationsController < Api::V1::BaseController
  def index
    @pagy, notifications = pagy(current_user.notifications.recent)
    render json: { data: notifications.map { |notification| Api::V1::NotificationSerializer.call(notification) }, meta: pagination_meta(@pagy) }
  end

  def show
    notification = current_user.notifications.find(params[:id])
    notification.update!(read_at: Time.current) if notification.read_at.blank?
    render json: { data: Api::V1::NotificationSerializer.call(notification) }
  end
end
