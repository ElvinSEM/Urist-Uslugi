module Api
  module V1
    class CategorySerializer
      def self.call(category)
        {
          id: category.id,
          name: category.name,
          slug: category.slug,
          description: category.description
        }
      end
    end
  end
end
