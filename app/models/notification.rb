class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  enum :channel, { in_app: 0, email: 1 }, default: :in_app

  scope :unread, -> { where(read_at: nil) }
end
