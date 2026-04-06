class ServiceRequest < ApplicationRecord
  include ActionView::RecordIdentifier

  audited associated_with: :service

  belongs_to :service, inverse_of: :service_requests
  belongs_to :client, class_name: "User", inverse_of: :service_requests
  belongs_to :lawyer, class_name: "User", inverse_of: :assigned_service_requests, optional: true

  has_many :notifications, as: :notifiable, dependent: :destroy, inverse_of: :notifiable

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2,
    rejected: 3
  }, default: :pending

  validates :full_name, :email, :phone, :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :with_status, ->(value) { where(status: value) if value.present? }
  scope :for_client, ->(client) { where(client: client) if client.present? }
  scope :for_lawyer, ->(lawyer) { where(lawyer: lawyer) if lawyer.present? }
  scope :assigned, -> { where.not(lawyer_id: nil) }
  scope :unassigned, -> { where(lawyer_id: nil) }

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
