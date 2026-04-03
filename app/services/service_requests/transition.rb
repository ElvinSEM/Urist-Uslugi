module ServiceRequests
  class Transition < ApplicationService
    VALID_STATUSES = ServiceRequest.statuses.keys.freeze

    def initialize(service_request:, status:, actor:, lawyer_id: nil)
      @service_request = service_request
      @status = status
      @actor = actor
      @lawyer_id = lawyer_id
    end

    def call
      raise ArgumentError, "invalid status" unless VALID_STATUSES.include?(status)

      service_request.with_lock do
        service_request.update!(
          status: status,
          lawyer_id: lawyer_id.presence || service_request.lawyer_id
        )
      end

      Notifications::Dispatch.call(
        user: service_request.client,
        title: "Статус заявки обновлен",
        body: "Заявка ##{service_request.id}: #{status}",
        notifiable: service_request
      )

      service_request
    end

    private

    attr_reader :service_request, :status, :actor, :lawyer_id
  end
end
