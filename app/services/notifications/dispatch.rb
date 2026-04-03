module Notifications
  class Dispatch < ApplicationService
    def initialize(user:, title:, body:, notifiable: nil)
      @user = user
      @title = title
      @body = body
      @notifiable = notifiable
    end

    def call
      Notification.create!(
        user: user,
        title: title,
        body: body,
        notifiable: notifiable,
        channel: :in_app
      )

      NotificationDeliveryJob.perform_later(user.id, title, body, notifiable&.class&.name, notifiable&.id)
    end

    private

    attr_reader :user, :title, :body, :notifiable
  end
end
