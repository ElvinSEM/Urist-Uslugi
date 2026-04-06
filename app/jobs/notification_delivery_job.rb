class NotificationDeliveryJob < ApplicationJob
  queue_as :mailers

  def perform(user_id, title, body, notifiable_type = nil, notifiable_id = nil)
    user = User.find(user_id)
    notifiable = notifiable_type&.constantize&.find_by(id: notifiable_id)
    Notification.create!(user: user, title: title, body: body, notifiable: notifiable)
    NotificationMailer.generic(user, title, body).deliver_now
  end
end
