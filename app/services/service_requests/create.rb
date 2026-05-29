require "securerandom"

module ServiceRequests
  class Create < ApplicationService
    GUEST_EMAIL = ENV.fetch("GUEST_CLIENT_EMAIL", "client@example.com")

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
      User.find_or_create_by!(email: GUEST_EMAIL) do |user|
        user.first_name = ENV.fetch("GUEST_CLIENT_FIRST_NAME", "Guest")
        user.last_name = ENV.fetch("GUEST_CLIENT_LAST_NAME", "Client")
        user.password = SecureRandom.hex(16)
        user.role = :client
      end
    end

    def permitted_params
      params.to_h.symbolize_keys
    end
  end
end
