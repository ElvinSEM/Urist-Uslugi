module Api
  module V1
    class NotificationSerializer
      def self.call(notification)
        {
          id: notification.id,
          title: notification.title,
          body: notification.body,
          channel: notification.channel,
          read_at: notification.read_at&.iso8601,
          created_at: notification.created_at.iso8601
        }
      end
    end
  end
end
