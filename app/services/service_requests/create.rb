module ServiceRequests
  class Create < ApplicationService
    def initialize(params:, actor:)
      @params = params
      @actor = actor
    end

    def call
      ServiceRequest.create!(
        permitted_params.merge(client: client)
      )
    end

    private

    attr_reader :params, :actor

    def client
      actor || guest_client
    end

    def guest_client
      User.find_by!(email: ENV.fetch("GUEST_CLIENT_EMAIL", "client@example.com"))
    end

    def permitted_params
      params.to_h.symbolize_keys
    end
  end
end
