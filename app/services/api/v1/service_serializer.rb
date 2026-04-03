module Api
  module V1
    class ServiceSerializer
      def self.call(service)
        {
          id: service.id,
          title: service.title,
          slug: service.slug,
          description: service.description,
          price_cents: service.price_cents,
          price: service.price,
          published: service.published,
          category: CategorySerializer.call(service.category)
        }
      end
    end
  end
end
