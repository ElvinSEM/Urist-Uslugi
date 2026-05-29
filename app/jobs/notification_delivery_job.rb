class NotificationDeliveryJob < ApplicationJob
  queue_as :mailers

  def perform(user_id, title, body, _notifiable_type = nil, _notifiable_id = nil)
    user = User.find(user_id)
    NotificationMailer.generic(user, title, body).deliver_now
  end
end
