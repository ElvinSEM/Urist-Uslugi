module Api
  module V1
    class ServiceRequestSerializer
      def self.call(record)
        {
          id: record.id,
          status: record.status,
          full_name: record.full_name,
          email: record.email,
          phone: record.phone,
          description: record.description,
          service: ServiceSerializer.call(record.service),
          client: UserSerializer.call(record.client),
          lawyer: record.lawyer && UserSerializer.call(record.lawyer),
          created_at: record.created_at.iso8601
        }
      end
    end
  end
end
