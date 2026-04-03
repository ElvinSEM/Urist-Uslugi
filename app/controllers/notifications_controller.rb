class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read_at: Time.current) if @notification.read_at.blank?
  end
end
