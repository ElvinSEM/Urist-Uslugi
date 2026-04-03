class ServiceRequest < ApplicationRecord
  include ActionView::RecordIdentifier

  audited associated_with: :service

  belongs_to :service
  belongs_to :client, class_name: "User"
  belongs_to :lawyer, class_name: "User", optional: true

  has_many :notifications, as: :notifiable, dependent: :destroy

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2,
    rejected: 3
  }, default: :pending

  validates :full_name, :email, :phone, :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :with_status, ->(value) { where(status: value) if value.present? }

  after_create_commit :enqueue_created_notification
  after_create_commit :broadcast_created
  after_update_commit :broadcast_updates

  private

  def enqueue_created_notification
    ProcessServiceRequestJob.perform_later(id)
  end

  def broadcast_created
    broadcast_prepend_later_to(
      [client, :service_requests],
      target: "service_requests",
      partial: "service_requests/service_request",
      locals: { service_request: self }
    )
  end

  def broadcast_updates
    broadcast_replace_later_to(
      [client, :service_requests],
      target: dom_id(self),
      partial: "service_requests/service_request",
      locals: { service_request: self }
    )

    broadcast_replace_later_to(
      self,
      target: dom_id(self, :panel),
      partial: "service_requests/panel",
      locals: { service_request: self }
    )
  end
end
